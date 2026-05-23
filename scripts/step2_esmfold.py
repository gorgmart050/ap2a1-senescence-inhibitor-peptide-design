#!/usr/bin/env python3
# Input: ./data/top_200_redesigned.fasta
# Output: Faltet alle 200 Sequenzen nach ./data/esmfold_structures/

import torch
import esm
import os

def main():
    print("=== Schritt 2: ESMFold (200 Faltungen) ===")
    fasta_input = "./data/top_200_redesigned.fasta"
    output_dir = "./data/esmfold_structures"
    os.makedirs(output_dir, exist_ok=True)
    
    if not os.path.exists(fasta_input):
        print(f"Fehler: {fasta_input} fehlt. Bitte Schritt 1 ausführen.")
        return

    print("Lade ESMFold-Modell auf CUDA...")
    device = "cuda" if torch.cuda.is_available() else "cpu"
    print(f"Nutze Device: {device}")
    
    model = esm.pretrained.esmfold_v1().eval()
    if device == "cuda":
        model = model.cuda()

    with open(fasta_input, 'r') as f:
        content = f.read().strip()
        if not content:
            print("Fehler: Die FASTA-Datei ist leer.")
            return
        entries = content.split('>')[1:]

    for idx, entry in enumerate(entries):
        lines = entry.strip().split('\n')
        sequence = "".join(lines[1:])
        pdb_path = os.path.join(output_dir, f"peptide_{idx+1}.pdb")
        
        print(f"[{idx+1}/{len(entries)}] Falte peptide_{idx+1}.pdb...")
        with torch.no_grad():
            output = model.infer_pdb(sequence)
        with open(pdb_path, "w") as f:
            f.write(output)
            
    print(f"Alle Strukturen in {output_dir}/ gespeichert.")

if __name__ == "__main__":
    main()
