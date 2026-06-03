# Results Summary — AP2A1 bioPROTAC Pipeline

All values below are directly extracted from AF3 server JSON outputs or BindCraft CSV.

---

## Phase 1 — Design 180 (Negative Result)

| AF3 job | ipTM (all 5 models) | inter-chain PAE | Interpretation |
|---|---|---|---|
| Design 180 + AP2A1 | 0.14–0.15 | ~28 Å | No interface — design invalid |

See [af3_validation/VALIDATION.md](af3_validation/VALIDATION.md) for full details.

---

## Phase 2 — BindCraft Accepted Designs

**One backbone accepted:** trajectory `l55_s869496`, two MPNN sequence variants.

| Design | Sequence | i_pTM | i_pAE | ShapeCompl. | Interface Res. | Unsat. Hbonds |
|---|---|---|---|---|---|---|
| mpnn2 (Binder #1, Rank 1) | `SEEEVYEKWDKVNEESYKILASSPPSKMKEAFEKVDKIEHEALIKMHEELKKVYS` | 0.82 | 0.20 | 0.71 | 25 | 1 |
| mpnn1 (Binder #2, Rank 2) | `SEEEVYKKWDEVNKKSYEILAKSPPEKMKEAFEEVDKIEHEALIKMHEELKKVYS` | 0.81 | 0.21 | 0.66 | 23 | 1 |

Raw BindCraft stats: [bindcraft_final_design_stats.csv](bindcraft_final_design_stats.csv)
Accepted PDB models + trajectory plots: [accepted_designs/](accepted_designs/)

---

## Phase 2 — AF3 Independent Validation (Binary Jobs)

Source files: [af3_binder_validation/](af3_binder_validation/)

| AF3 job | Model 0 | Model 1 | Model 2 | Model 3 | Model 4 | Interpretation |
|---|---|---|---|---|---|---|
| Binder #1 + AP2A1 ear | 0.93 | 0.93 | 0.92 | 0.92 | 0.92 | Robust binding |
| Binder #2 + AP2A1 ear | 0.92 | — | — | — | — | Robust across variants |
| Scramble + AP2A1 ear | 0.14 | — | — | — | — | Ear not sticky (control) |
| Binder #1 + ubiquitin | 0.21 | — | — | — | — | Binder not sticky (control) |
| Binder #1 + AP2A2 ear | **0.93** | — | — | — | — | **Cross-reactive — FAIL** |

*Only the Binder #1 + AP2A1 ear job has all 5 models stored locally (see af3_binder_validation/). Other jobs: summary values from AF3 server session.*

Epitope: AP2A1 ear residues ~750–917. Conserved in 28–30/30 contact positions across models.
Free lysines near interface: Lys746, Lys810, Lys863, Lys907.

---

## Phase 2 — AF3 Ternary Complex (bioPROTAC Model)

**Construct:** Binder #1 + (GGGGS)×3 + VHL + ELOB + ELOC + AP2A1 ear (4 chains).
Source files: [af3_ternary_complex/](af3_ternary_complex/)

**Overall ipTM across models:** 0.50–0.52 (misleading aggregate; see chain pairs below).

Chain-pair ipTM matrix (model 0). Chain order: A=Fusion(Binder+linker+VHL), B=ELOB, C=ELOC, D=Ear.

| | A (Fusion) | B (ELOB) | C (ELOC) | D (Ear) |
|---|---|---|---|---|
| **A (Fusion)** | 0.53 | 0.80 | 0.85 | **0.86** |
| **B (ELOB)** | 0.80 | 0.78 | 0.82 | 0.10 |
| **C (ELOC)** | 0.85 | 0.82 | 0.78 | 0.12 |
| **D (Ear)** | **0.86** | 0.10 | 0.12 | 0.89 |

`has_clash: 0` across all 5 models.

Key PAE (model 0): Fusion–Ear 1.72 Å (well-determined); Ear–ELOB 25.1 Å, Ear–ELOC 24.8 Å (underdetermined by linker — expected).

---

## Selectivity Summary — Decisive Negative Result

AP2A2 ear (residues ~697–939): 71% sequence identity to AP2A1 ear. Binder epitope: 88% conserved (29/33 contact residues identical; 4 conservative substitutions: V765→L, Y777→F, L909→I, D917→E).

**Binder #1 + AP2A2 ear AF3 result: ipTM 0.93 — identical to AP2A1.**

**Conclusion: binder is pan-α-adaptin. Degrader concept not viable with this binder.**
