# Scripts

## Phase 1 — Design 180 Pipeline Scripts

These scripts implement the original cascade pipeline (ProteinMPNN → ESMFold → LightDock) that produced Design 180.

| Script | Description |
|---|---|
| `step1_proteinmpnn.py` | Sequence generation (ProteinMPNN); extracts top 200 by log-likelihood |
| `step2_esmfold.py` | Local GPU folding of top 200 candidates (ESMFold) |
| `step3_lightdock.sh` | LightDock rigid-body docking for top 10 pLDDT leads |

Phase 1 ended in a negative AF3 validation (Design 180 ipTM 0.14–0.15). See `results/af3_validation/VALIDATION.md`.

---

## Phase 2 — Analyses Performed (no standalone scripts saved)

The Phase 2 analyses were performed interactively and not saved as standalone scripts. Descriptions below allow reproduction:

| Analysis | Method used |
|---|---|
| **Ear domain extraction** (residues 735–977 from AF-O95782-F1-model_v6.pdb) | PyMOL `select` + `save`, or BioPython `PDBIO` with residue range filter |
| **BindCraft run** | FreeBindCraft (`--no-pyrosetta`), target = `data/AP2A1ear_target.json`, settings as documented in README §4 |
| **Epitope / contact analysis** | PyMOL `select byres (binder within 4.5 of ear)`, count unique residues; repeated per AF3 model |
| **AP2A1 ↔ AP2A2 sequence alignment** | Biopython `pairwise2.align.globalds` (BLOSUM62) on UniProt O95782 (residues 735–977) vs O94973 (residues 697–939); identity computed over aligned region |
| **Epitope-conservation calculation** | Intersection of contact residues (from epitope analysis) with identical positions in the alignment; conservative/non-conservative classification by eye |
| **Scramble sequence generation** | Fisher-Yates shuffle of Binder #1 amino acid composition; re-shuffled until no 5-mer matches Binder #1 |
| **Fusion construct assembly** | Concatenation of Binder #1 sequence + `GGGGSGGGGSGGGGSGGGGS` linker + VHL sequence (UniProt P40337, isoform 1, residues 1–213) as a single FASTA entry; submitted to AF3 server |
| **AlphaFold3 jobs** | AF3 web server (alphafoldserver.com); all jobs submitted manually; summary confidence JSONs stored in `results/` |
