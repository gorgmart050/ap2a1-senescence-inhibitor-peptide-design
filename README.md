# AP2A1 Senescence — Computational Triage Pipeline

**Status: Closed — well-characterised negative (selectivity failure). Documented transparently.**

A self-directed computational project building on Deguchi et al. (Cellular Signalling, 2025, Osaka), who identified AP2A1 as a senescence-associated protein whose siRNA knockdown reverses senescence markers. The project pivoted from an (unfounded) small-interface "inhibitor" idea to a **targeted-degradation (bioPROTAC) strategy**, designed a de novo binder to the human AP2A1 appendage ("ear") domain, validated it independently, modeled a bioPROTAC ternary complex, and then **falsified the therapeutic premise** via a paralog-selectivity test: the binder is **pan-α-adaptin** (binds AP2A2 as well as AP2A1), so it is not viable as a *selective* AP2A1 degrader. All work is in silico; no wet-lab validation.

> **Note on repo name:** The name still says "inhibitor-peptide-design" because the strategy pivoted mid-project. The work described here is a **degrader (bioPROTAC)** strategy, not an inhibitor. A repo rename to reflect this is pending.

---

## Table of Contents

1. [Background & Target Rationale](#1-background--target-rationale)
2. [Strategy Pivot — Inhibitor to Degrader](#2-strategy-pivot--inhibitor-to-degrader)
3. [Target Structure](#3-target-structure)
4. [BindCraft Binder Design](#4-bindcraft-binder-design)
5. [Independent Validation (AlphaFold3)](#5-independent-validation-alphafold3)
6. [bioPROTAC Ternary Complex Modeling](#6-biprotac-ternary-complex-modeling)
7. [Selectivity Test & Decisive Negative Result](#7-selectivity-test--decisive-negative-result)
8. [Honest Conclusion](#8-honest-conclusion)
9. [Limitations](#9-limitations)
10. [Installation & Reproduction](#10-installation--reproduction)
11. [Repository Structure](#11-repository-structure)
12. [Contact](#12-contact)

---

## 1. Background & Target Rationale

**Target:** AP2A1 — AP-2 complex subunit alpha-1, UniProt O95782.

**Why AP2A1?** Deguchi et al. (2025, Osaka, Cellular Signalling) showed that AP2A1 is upregulated in senescent human cells, accumulates along stress fibers, and — critically — **siRNA knockdown of AP2A1 reverses senescence markers**: cells become smaller, p53/p21 expression drops, and SA-β-galactosidase activity decreases. AP2A1 is proposed to transport integrin β1 along stress fibers (colocalization by microscopy; no structural binding data).

**Key mechanistic insight:** AP2A1 is a **knockdown target (protein amount)**, not a classical inhibitor target. There is **no characterized druggable pocket** whose blockade would recapitulate the siRNA phenotype. A small-molecule inhibitor of a pocket would silence a function; the Deguchi phenotype requires *removing the protein*. This distinction drove the strategy pivot (§2).

---

## 2. Strategy Pivot — Inhibitor to Degrader

### Phase 1 — Design 180 (Negative Result, documented)

The original framing (visible in the repo name) was to design a peptide inhibitor against a so-called "Platform-Site" on AP2A1. That site had **no basis in the primary literature** — it traced to an AI suggestion, not to Deguchi et al. or any structural biology source.

The resulting champion, **Design 180**, was independently re-evaluated by predicting the full AP2A1 + Design 180 complex with AlphaFold3 (a model entirely separate from the ProteinMPNN/LightDock pipeline that produced it):

| AF3 prediction | ipTM | inter-chain PAE | Interpretation |
|---|---|---|---|
| Design 180 + AP2A1 | 0.14–0.15 | ~28 Å | **No defined interface — binding not confirmed** |

AlphaFold3 found that each chain folds well in isolation but predicts no preferred binding orientation between Design 180 and AP2A1. **Design 180 is not a validated binder.** Full details: [results/af3_validation/VALIDATION.md](results/af3_validation/VALIDATION.md).

**Lesson:** Single-tool docking scores (LightDock) are unreliable without independent structure prediction. AF3 validation is mandatory.

### Phase 2 — Pivot to Targeted Protein Degradation (bioPROTAC)

The correct mechanistic target for Deguchi's phenotype is **protein amount** — matching siRNA knockdown. A binder that tags AP2A1 for proteasomal degradation (bioPROTAC strategy) achieves this. Crucially:

- A degrader binder only needs to **bind firmly somewhere on AP2A1** — no functional pocket required.
- The binder can be fused to an E3 ubiquitin ligase recruiter (e.g., VHL-binding domain) to form a bioPROTAC.
- This mechanistically matches Deguchi's knockdown: lower protein *amount*, not just altered activity.

---

## 3. Target Structure

- **Domain used:** Human AP2A1 appendage ("ear") domain, **residues 735–977** (243 aa).
- **Source:** AlphaFold DB model **AF-O95782-F1 (v6, canonical isoform)** — `data/AF-O95782-F1-model_v6.pdb`.
- **Extraction:** Residues 735–977 extracted as `data/AP2A1_ear_human.pdb`.
- **Quality:** Mean pLDDT **92.1**, no residue < 70 (cleanly folded).
- **Note on crystal structures:** Classic appendage crystal structures (e.g., 1QTP, 1W85) are rodent αC; the human AlphaFold model was used for sequence fidelity to Deguchi's AP2A1.

---

## 4. BindCraft Binder Design

**Tool:** FreeBindCraft (PyRosetta-free fork), run with `--no-pyrosetta`, CUDA 12.4, local on an RTX 4060 laptop (8 GB VRAM), WSL2/Ubuntu, conda env `BindCraft`.

**Settings:**
- Target: ear domain, chain A
- `target_hotspot_residues`: **empty** (whole-surface scan — consistent with degrader rationale; no functional pocket needed)
- `lengths [50, 75]`
- `default_filters`, `default_4stage_multimer`

**Outcome:**
- **1 accepted backbone** (trajectory `l55_s869496`), 2 MPNN sequence variants.
- A ~2-day overnight resume run produced **no additional accepted backbones** (low acceptance rate; diversity is limited to one backbone — reported honestly).

### Accepted Binder Sequences (~55-residue helical binder)

| Name | Sequence |
|---|---|
| **Binder #1** (mpnn2, Rank 1) | `SEEEVYEKWDKVNEESYKILASSPPSKMKEAFEKVDKIEHEALIKMHEELKKVYS` |
| **Binder #2** (mpnn1, Rank 2) | `SEEEVYKKWDEVNKKSYEILAKSPPEKMKEAFEEVDKIEHEALIKMHEELKKVYS` |

### BindCraft Interface Metrics (AF2-based, from `results/bindcraft_final_design_stats.csv`)

| Metric | Binder #1 | Binder #2 |
|---|---|---|
| Average i_pTM | 0.82 | 0.81 |
| Average i_pAE | 0.20 | 0.21 |
| ShapeComplementarity | 0.71 | 0.62 |
| n_InterfaceResidues | 25 | 23 |
| n_InterfaceUnsatHbonds | 1 | 1 |

*Note: PyRosetta-derived columns (dG, dSASA) are placeholder values (`-1.0`, `-10.0`) under `--no-pyrosetta` — ignore those columns.*

---

## 5. Independent Validation (AlphaFold3)

AF3 is a model entirely outside the BindCraft loop — its prediction constitutes independent validation. Four jobs were run: two positive, two controls.

| AF3 job | ipTM (all 5 models) | Interpretation |
|---|---|---|
| **Binder #1 + AP2A1 ear** | **0.92–0.93** | Robust binding confirmed |
| **Binder #2 + AP2A1 ear** | **0.92** | Binding robust across sequence variants |
| Scramble + AP2A1 ear | 0.14 | Ear is not non-specifically sticky (control) |
| Binder #1 + ubiquitin | 0.21 | Binder is not non-specifically sticky (control) |

**Epitope:** Conformational patch on AP2A1 ear residues ~750–917, spanning both appendage lobes. Conserved in 28–30 of 30 contact residues across 5 AF3 models (93%).

**Free lysines near the interface:** Lys746, Lys810, Lys863, Lys907 — candidate ubiquitination sites for a degrader construct.

**Contrast with Design 180:** Design 180 scored ipTM 0.14–0.15 (same level as the scramble negative control). The binder designed here scores 0.92–0.93.

AF3 summary confidence JSON files: `results/af3_binder_validation/`.

---

## 6. bioPROTAC Ternary Complex Modeling

**Fusion construct:** Binder #1 + (GGGGS)×3 linker + VHL (UniProt P40337).
**E3 module:** VHL + Elongin B (Q15370) + Elongin C (Q15369).
**AF3 job:** [Fusion + ELOB + ELOC + Ear] — 4 chains.

### Overall ipTM: 0.50–0.52 — a misleading aggregate

| Chain pair | ipTM (model 0) | Interpretation |
|---|---|---|
| Fusion–Ear | **0.86** | Binder hits same epitope as binary job (27/28 residues conserved) |
| Fusion–ELOB | 0.80 | E3 module assembles correctly |
| Fusion–ELOC | 0.85 | E3 module assembles correctly |
| ELOB–ELOC | 0.82 | E3 module assembles correctly |
| Ear–ELOB | ~0.10 | Underdetermined — expected from flexible linker |
| Ear–ELOC | ~0.12 | Underdetermined — expected from flexible linker |

`has_clash: 0` across all 5 models.

The low overall ipTM (0.52) is driven by the module-to-module geometry being **underdetermined by the flexible (GGGGS)×3 linker** — this is expected, not a defect. The two functional modules (binder+ear; VHL+ELOB+ELOC) assemble well independently.

**Honest limit:** A productive ubiquitination geometry cannot be determined in silico with a flexible linker. Verifying that the E2-Ub thioester conjugate can reach a lysine on AP2A1 within the full CRL2 complex would require wet-lab or dedicated computational methods (CRL modelling with E2-Ub).

AF3 summary confidence JSON files: `results/af3_ternary_complex/`.

---

## 7. Selectivity Test & Decisive Negative Result

**Paralog tested:** AP2A2 (UniProt O94973). The AP-2 complex contains two alpha-adaptin paralogs, AP2A1 and AP2A2, with **71% sequence identity** in their ear domains.

**Contact-residue analysis:**
- The binder's epitope on the AP2A1 ear uses ~33 contact residues.
- **29/33 are identical in AP2A2** (88% conserved).
- The 4 differences are all **conservative substitutions**: V765→L, Y777→F, L909→I, D917→E.

**AF3 result — Binder #1 + AP2A2 ear:**

| AF3 job | ipTM | Interpretation |
|---|---|---|
| Binder #1 + AP2A2 ear | **0.93** | **Cross-reactive — not selective** |

The binder scores identically on AP2A2 and AP2A1. It is a **pan-α-adaptin binder**, not an AP2A1-selective binder.

**Why this matters:**
- AP-2 is essential for clathrin-mediated endocytosis; the alpha subunit function is shared (redundant) between AP2A1 and AP2A2.
- Single-paralog loss is buffered by the other; **dual loss is likely toxic**.
- A degrader built on this binder would remove both paralogs → expected toxicity.
- **Selective AP2A1 degradation is the only tolerable route, and this binder fails selectivity.**

**The degrader-for-senescence concept is not viable with this binder.**

### Follow-up: Selectivity Redesign (Two BindCraft Runs, Zero Accepted Designs)

To test whether a *selective* binder could be found by targeting the divergent Cluster B surface (residues 786–817), two additional BindCraft runs were performed with forced hotspots:

- **Run 1** (`ear_run_selective`): all 7 divergent residues as hotspots (A786, A797, A799, A800, A807, A808, A811) — 22 trajectories, 0 accepted.
- **Run 2** (`ear_run_selective_v2`): 3 exposed-only hotspots (A800, A808, A811) after SASA analysis showed A786/A797/A807 are partially buried — 19 trajectories, 0 accepted.

In both runs, the MPNN i_pAE filter failed for ~97–100 % of all designs (428/439 in Run 1; 380/380 in Run 2). Backbone quality was adequate (Run 2 i_pTM max 0.89, pLDDT max 0.93, SC max 0.75), so the failure is not due to a repulsive surface — it is a **designability gap**: the Cluster B surface is topologically flat with no pocket, and MPNN cannot generate sequences that reproduce the interface position-specifically. Removing the buried hotspots (Run 2) did not change the outcome.

Full details, verified numbers, and interpretation: [results/selectivity_redesign_negative.md](results/selectivity_redesign_negative.md).

---

## 8. Honest Conclusion

A validated, robust, well-controlled de novo binder to the α-adaptin appendage was designed and independently corroborated (ipTM 0.92–0.93 across 5 models, two sequence variants, two negative controls), and a coherent bioPROTAC ternary construct was modeled. **However**, the binder is pan-α-adaptin and is not suitable as a *selective* AP2A1 degrader; the therapeutic concept is not viable as designed. Two follow-up BindCraft runs targeting the divergent Cluster B surface produced zero accepted designs, confirming that AP2A1-selective surface binding is not achievable with this approach.

**Why selectivity is a protein-surface problem with no solution here:** Deguchi et al. (2025) show that AP2A1's role in senescence is its *upregulation and relocalization along stress fibers* — a quantity/localization effect, not an enzymatic or allosteric function. AP2A2 performs the same endocytic role under basal conditions. The selectivity difference between the two paralogs exists at the **transcript level** (mRNA sequences diverge sufficiently for siRNA/ASO selectivity); the protein surfaces are ~88 % identical at the binder epitope. A protein binder cannot exploit RNA-level divergence. The correct therapeutic modality for AP2A1-selective intervention is **transcript-level (siRNA/ASO)**, consistent with Deguchi's own experimental approach.

**Project value:** A demonstration of an honest computational triage pipeline that rigorously delineates *why* the protein-binder route fails for AP2A1 selectivity — before any wet-lab work. Three independent lines of evidence converge: (1) pan-adaptin binding, (2) divergent patch unbindable, (3) ternary geometry underdetermined. Both negative results are retained in this repository as part of the project's honest arc.

**All work is in silico.** Binding predictions ≠ measured affinity. Degradation, cell entry, and cellular effects are unproven and require wet-lab work.

---

## 9. Limitations

- **In silico only.** No SPR, ITC, or cellular data. AF3 ipTM is a confidence score, not a binding affinity.
- **One backbone.** BindCraft produced only one accepted backbone trajectory; design diversity is limited.
- **Flexible linker — ternary geometry underdetermined.** The (GGGGS)×3 linker leaves module-to-module orientation unconstrained; productive ubiquitination geometry cannot be assessed in silico.
- **No full CRL2 modelling.** E2-Ub reach to target lysines was not modeled.
- **Consumer hardware.** Run on RTX 4060 (8 GB VRAM); a longer run on higher VRAM hardware might yield more backbone diversity.
- **AF3 selectivity test only.** AP2A2 cross-reactivity was identified by AF3 prediction; selectivity would need SPR or cell-based degradation assays to confirm.

---

## 10. Installation & Reproduction

### Tool

**FreeBindCraft** — PyRosetta-free fork of BindCraft by cytokineking:
[https://github.com/cytokineking/FreeBindCraft](https://github.com/cytokineking/FreeBindCraft)

The `--no-pyrosetta` flag eliminates the PyRosetta license requirement; relaxation runs via OpenMM (GPU-accelerated) and shape complementarity via `sc-rs`.

### Environment (as run)

| Item | Value |
|---|---|
| OS | WSL2 / Ubuntu |
| GPU | RTX 4060 laptop, 8 GB VRAM |
| CUDA | 12.4 |
| conda env | `BindCraft` |
| FreeBindCraft commit | `d12747d` |

### Install steps (verified against FreeBindCraft README and `install_bindcraft.sh`)

```bash
# 1. Clone
git clone https://github.com/cytokineking/FreeBindCraft ~/FreeBindCraft
cd ~/FreeBindCraft

# 2. Install (PyRosetta-free, CUDA 12.4)
#    The script creates the "BindCraft" conda env, pins JAX 0.6.0 + CUDA deps,
#    installs ColabDesign, and downloads AlphaFold2 weights (~3.5 GB).
bash install_bindcraft.sh --cuda '12.4' --pkg_manager 'conda' --no-pyrosetta

# 3. Activate
conda activate BindCraft
```

### GPU check (must show a GPU device before running)

```bash
python -c "import jax; print(jax.devices())"
# Expected: [CudaDevice(id=0)] or similar — not [CpuDevice(id=0)]
```

### 8 GB VRAM note

JAX preallocates GPU memory by default, causing OOM on 8 GB cards. Set these before running:

```bash
export XLA_PYTHON_CLIENT_PREALLOCATE=false
export XLA_PYTHON_CLIENT_ALLOCATOR=platform
```

Also keep `lengths` small (e.g., `[50, 75]`) to limit per-design memory.

### Target PDB preparation

`data/AP2A1_ear_human.pdb` must be extracted before running BindCraft. It is the ear domain of
AlphaFold model **AF-O95782-F1 v6** (`data/AF-O95782-F1-model_v6.pdb`), residues 735–977, chain A.
Use PyMOL (`select ear, resi 735-977 and chain A` → `save`) or BioPython `PDBIO` with a residue
range filter.

### Run

```bash
bash scripts/run_bindcraft.sh
```

See `scripts/run_bindcraft.sh` for the exact invocation and paths used.
The target settings are in `data/AP2A1ear_target.json`.

---

## 11. Repository Structure

```
ap2a1-senescence-inhibitor-peptide-design/
├── data/
│   ├── AF-O95782-F1-model_v6.pdb        # AlphaFold DB model of full human AP2A1 (v6)
│   ├── AP2A1_ear_human.pdb               # Extracted ear domain, residues 735–977
│   ├── AP2A1ear_target.json              # BindCraft target specification JSON
│   └── AP2A1_target_structure.pdb        # Target used in Phase 1 (Design 180)
├── scripts/
│   ├── README.md                         # Index of analyses performed (see note)
│   ├── run_bindcraft.sh                  # Phase 2: BindCraft run command (see §10)
│   ├── step1_proteinmpnn.py              # Phase 1: sequence generation
│   ├── step2_esmfold.py                  # Phase 1: ESMFold structure prediction
│   └── step3_lightdock.sh                # Phase 1: LightDock docking
├── results/
│   ├── af3_validation/                   # Phase 1: Design 180 AF3 negative result
│   ├── Design180_sequence.txt            # Phase 1: Design 180 sequence
│   ├── Design180_docked_complex.pdb      # Phase 1: Design 180 docked pose
│   ├── Design180_binding_site.png        # Phase 1: Visualisation
│   ├── bindcraft_final_design_stats.csv  # Phase 2: BindCraft accepted design stats
│   ├── accepted_designs/                 # Phase 2: Accepted PDB + trajectory plots
│   ├── af3_binder_validation/            # Phase 2: AF3 binary validation (Binder#1 + ear)
│   ├── af3_ternary_complex/              # Phase 2: AF3 ternary complex modeling
│   └── selectivity_redesign_negative.md  # Phase 3: Two redesign runs, 0 accepted — designability gap
└── README.md
```

**Note on analysis scripts (Phase 2):** The Phase 2 analyses (ear extraction from the AlphaFold model, epitope/contact analysis, AP2A1↔AP2A2 alignment and epitope-conservation calculation, scramble-sequence generation, fusion construct assembly) were performed interactively using PyMOL, BioPython, and the AlphaFold3 server. Standalone scripts were not saved during the session. `scripts/README.md` records which analyses were performed, so they can be reproduced or scripted later.

---

## 12. Contact

**Contact:** Georg — georgmartazov@gmail.com
