#!/usr/bin/env python3
# Input: ./data/AP2A1_target_structure.pdb
# Output: ./data/top_200_redesigned.fasta

import os
import subprocess
import sys

MPNN_DIR = os.environ.get("MPNN_DIR", "/home/georg/ProteinMPNN")
INPUT_PDB = "./data/AP2A1_target_structure.pdb"
OUTPUT_DIR = "./data/mpnn_outputs"
TOP_200_FASTA = "./data/top_200_redesigned.fasta"
N_SEQS = 10000
TOP_N = 200


def run(cmd: list[str]) -> None:
    print("$", " ".join(cmd))
    result = subprocess.run(cmd, check=True)
    if result.returncode != 0:
        sys.exit(result.returncode)


def main():
    print("=== Schritt 1: ProteinMPNN Generation & Filter ===")
    os.makedirs(OUTPUT_DIR, exist_ok=True)

    if not os.path.exists(INPUT_PDB):
        print(f"Fehler: {INPUT_PDB} fehlt.")
        sys.exit(1)

    parsed_json = os.path.join(OUTPUT_DIR, "parsed.jsonl")
    run([
        "python", os.path.join(MPNN_DIR, "helper_scripts/parse_multiple_chains.py"),
        "--input_path", "./data",
        "--output_path", parsed_json,
    ])

    run([
        "python", os.path.join(MPNN_DIR, "protein_mpnn_run.py"),
        "--jsonl_path", parsed_json,
        "--out_folder", OUTPUT_DIR,
        "--num_seq_per_target", str(N_SEQS),
        "--sampling_temp", "0.1",
        "--seed", "42",
        "--batch_size", "1",
    ])

    # Filter top N by lowest (best) score
    fa_path = os.path.join(OUTPUT_DIR, "seqs", "AP2A1_target_structure.fa")
    if not os.path.exists(fa_path):
        print(f"Fehler: ProteinMPNN-Output {fa_path} nicht gefunden.")
        sys.exit(1)

    with open(fa_path) as f:
        entries = f.read().split(">")[1:]

    parsed = []
    for entry in entries:
        lines = entry.strip().split("\n")
        if not lines:
            continue
        header = lines[0]
        seq = "".join(lines[1:])
        if "score=" not in header:
            continue
        score = float(header.split("score=")[1].split(",")[0])
        parsed.append((score, header, seq))

    parsed.sort(key=lambda x: x[0])

    with open(TOP_200_FASTA, "w") as out:
        for score, header, seq in parsed[:TOP_N]:
            out.write(f">{header}\n{seq}\n")

    print(f"Top {min(TOP_N, len(parsed))} Sequenzen gespeichert: {TOP_200_FASTA}")


if __name__ == "__main__":
    main()
