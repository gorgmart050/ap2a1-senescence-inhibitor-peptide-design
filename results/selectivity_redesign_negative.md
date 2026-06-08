# Selectivity Redesign — Two Runs, Zero Accepted Designs

**Date:** 2026-06-08  
**Context:** Following the decisive negative in §7 of the main README (binder cross-reactive with AP2A2, ipTM 0.93 on both paralogs), two BindCraft runs attempted to design a binder that is *selective* for AP2A1 by forcing hotspots onto the divergent Cluster B surface (residues 786–817). Both runs produced zero accepted designs.

---

## 1. Candidate Hotspot Analysis — SASA/RSA

The AP2A1 ear residues that differ from AP2A2 were mapped to the AlphaFold model to identify which divergent positions are surface-accessible and thus worth targeting. Relative solvent-accessible surface area (RSA) was computed interactively from `data/AP2A1_ear_human.pdb` (no disk CSV preserved).

| Residue | Identity in AP2A2 | RSA (AP2A1) | Classification |
|---|---|---|---|
| A811 | divergent | 87 % | exposed |
| A799 (Gly) | divergent | 65 % | exposed |
| A800 (Asp) | divergent | 59 % | exposed |
| A808 (Gln) | divergent | 55 % | exposed |
| A786 | divergent | 35 % | partially buried |
| A797 | divergent | 20 % | buried |
| A807 | divergent | 18 % | buried |

Residues A786, A797, A807 are partially or fully buried — they are not surface-accessible contact positions in the apo structure. Including buried residues as hotspots forces BindCraft to design against positions that cannot form an interface in a standard binder geometry.

---

## 2. Run Configurations

| | Run 1 (`ear_run_selective`) | Run 2 (`ear_run_selective_v2`) |
|---|---|---|
| JSON | `AP2A1ear_selective_target.json` | `AP2A1ear_selective_v2.json` |
| Hotspots | A786,A797,A799,A800,A807,A808,A811 (7, all divergent) | A800,A808,A811 (3, exposed only) |
| Lengths | [50, 75] | [50, 75] |
| Filters | `default_filters` | `default_filters` |
| Protocol | `default_4stage_multimer` | `default_4stage_multimer` |

Run 2 was designed to remove the three buried hotspots (A786, A797, A807) as a possible explanation for Run 1's failure.

---

## 3. Results

All numbers below are read directly from disk CSVs:
- Trajectory counts: `trajectory_stats.csv` (lines − 1 header)
- Failure counts: `failure_csv.csv` (second row, columns `i_pAE`, `i_pTM`, `pLDDT`)
- Accepted: `final_design_stats.csv` (lines − 1 header)
- Total MPNN evaluated: `rejected_mpnn_full_stats.csv` (lines − 1 header) + accepted

| Metric | Run 1 | Run 2 |
|---|---|---|
| Trajectories | 22 | 19 |
| Accepted designs | **0** | **0** |
| Total MPNN designs evaluated | 439 | 380 |
| i_pAE filter failures | 428 (97.5 %) | **380 (100 %)** |
| i_pTM filter failures | 393 (89.5 %) | 329 (86.6 %) |
| pLDDT filter failures | 112 (25.5 %) | 97 (25.5 %) |

---

## 4. Trajectory Backbone Quality

Backbone quality metrics from `trajectory_stats.csv`. These measure how well the RFdiffusion backbone samples the hotspot surface *before* MPNN sequence design.

| Metric | Run 1 | Run 2 |
|---|---|---|
| i_pTM max | 0.87 | 0.89 |
| i_pTM mean | 0.49 | 0.58 |
| pLDDT max | 0.91 | 0.93 |
| ShapeComplementarity max | 0.68 | 0.75 |
| i_pAE (backbone, mean) | 0.47 | 0.40 |

The best trajectory in Run 2 reached i_pTM 0.89, pLDDT 0.93, SC 0.75 — values comparable to the accepted binder in the original whole-surface run (i_pTM 0.82, SC 0.71). The surface is not topologically repulsive to backbone generation.

---

## 5. Interpretation — The i_pAE Wall

The decisive failure is at the MPNN i_pAE filter: 100 % of Run 2 designs (380/380) fail, and 97.5 % of Run 1 designs (428/439) fail. i_pAE measures AF2's predicted inter-chain alignment error; high values mean AF2 cannot place the binder confidently onto the target.

This is not a filter artefact. The same `default_filters` threshold accepted Binder #1 in the original whole-surface run (i_pAE = 0.20; threshold typically < 0.3–0.4). The threshold is unchanged between runs.

The consistent interpretation: MPNN can generate sequences that fold well in isolation, but AF2 cannot reproduce the interface at the Cluster B patch with any designed sequence. The Cluster B surface (residues ~786–817) is topologically flat — no pocket, no concave groove — and the divergent residues between AP2A1 and AP2A2 are scattered on this flat face. A de novo miniprotein binder typically requires a geometrically defined contact surface; a flat, exposed loop region does not provide one.

Removing the buried hotspots (Run 1 → Run 2) did not break through the i_pAE wall. The backbone quality actually improved slightly (mean i_pTM 0.49 → 0.58) but the MPNN+AF2 designability remained zero. The bottleneck is not the hotspot burial; it is the flatness of the accessible surface.

---

## 6. Ternary Analysis — No Geometric Selectivity Either

The bioPROTAC ternary model (`results/af3_ternary_complex/`) shows an additional limitation beyond sequence selectivity:

- Fusion–Ear ipTM: **0.86** (same unselective binding as binary job)
- Ear–ELOB: **0.10**, Ear–ELOC: **0.12** (Ear–E3 PAE ~25 Å, underdetermined)
- `has_clash: 0` across all 5 models

The E3 complex floats on the flexible (GGGGS)₃ linker with no defined ternary geometry. Even if a selective binder were found, the flexible linker would not impose AP2A1-specific spatial orientation of the E3. Geometric selectivity via the ternary construct is not achievable with this design.

Full ipTM matrix: see [SUMMARY.md](SUMMARY.md#phase-2--af3-ternary-complex-bioproteac-model).

---

## 7. Mechanistic Context — Why Protein-Surface Selectivity Was the Wrong Frame

Deguchi & Chantachotikul et al. (*Cellular Signalling*, 2025, DOI 10.1016/j.cellsig.2025.111616) show that AP2A1:

- Is **upregulated in senescent fibroblasts** and accumulates along stress fibers.
- **Colocalizes with integrin β1**; both migrate along stress fibers and reinforce focal adhesions.
- Knockdown **reverses senescence markers** (cell size, p53/p21, SA-β-gal).
- Is a **quantity/localization effect**, not a classical catalytic or allosteric target.

AP2A2 performs the same endocytic function at steady state. The senescence-specific role of AP2A1 is its upregulation and relocalization. This distinction lives at the **expression and localization level**, not in the protein surface.

Consequently:
- The protein surfaces of AP2A1 and AP2A2 ear domains are ~88 % identical at the binder contact epitope (29/33 residues conserved).
- The 4 divergent positions (V765→L, Y777→F, L909→I, D917→E) are conservative and topologically scattered.
- Protein-level selectivity via a surface binder is structurally not achievable.

The correct therapeutic modality — matching Deguchi's own experimental approach — is **transcript-level intervention (siRNA/ASO)**: the AP2A1 and AP2A2 mRNA sequences diverge sufficiently for oligonucleotide selectivity, which is not available to a protein binder.

---

## 8. Conclusion

Three independent lines of evidence converge:

1. **Binder cross-reactive** (AP2A2 ear ipTM 0.93 = AP2A1 ipTM 0.93): surfaces are nearly identical.
2. **Divergent patch unbindable** (two redesign runs, 0/819 MPNN designs accepted): Cluster B is too flat for de novo miniprotein design.
3. **Ternary geometry underdetermined** (Ear–E3 PAE ~25 Å): a selective ternary geometry is not achievable with a flexible linker.

These are not independent misfortunes — they reflect a common underlying biology: AP2A1 selectivity is an **expression- and RNA-level problem**, not a protein-surface problem.

**A surface-selective protein binder/degrader for AP2A1 is not a viable approach.** This project has documented *rigorously why* the protein-binder route fails for AP2A1 selectivity.
