# Changelog

## 2026-06-18 — Finalize negative: structural-biology rationale + verified literature

- Added `results/ap2a1_closure_structural_rationale.md`: literature-grounded explanation of why a selective AP2A1 binder/degrader (and the integrin-β1 composite route) is not tractable *in principle*, independent of the design runs. Four points: (1) AP2 is an obligate heterotetramer (no free targetable AP2A1); (2) the α-appendage reads DPF/DPW + FxDxF motifs that integrins lack (no direct α-ear–integrin interface); (3) integrin–AP2 coupling runs through μ2 and PTB adapters Dab2/Numb → any AP2A1–integrin-β1 link is indirect; (4) primary evidence is colocalization/co-movement, not a defined binding interface (no design template).
- All six citations verified against CrossRef (title, authors, journal, volume, pages, DOI) before commit. Correction vs. internal notes: Owen et al. 1999 is Cell 97(6):**805–815**, not 805–816.
- Updated `README.md`: status line to "Closed — documented negative" (empirical + structural); added "Structural rationale" subsection to §8; added the new doc to the §11 repository structure.
- Clear separation maintained: **empirical negative** (design runs) vs. **structural rationale** (literature). Existing negative docs were extended, not replaced.

## 2026-06-08 — Selectivity redesign negative + project closure

- Added `results/selectivity_redesign_negative.md`: documents two BindCraft selectivity redesign runs (ear_run_selective, ear_run_selective_v2), both producing zero accepted designs. Includes verified run statistics, backbone quality data, i_pAE wall interpretation, ternary geometry analysis, Deguchi 2025 mechanistic context, and strategic conclusion.
- Updated `README.md` §7: added "Follow-up: Selectivity Redesign" subsection summarising the two runs.
- Updated `README.md` §8: extended Honest Conclusion with explanation of why selectivity is an expression/RNA-level problem (not a protein-surface problem), referencing Deguchi et al. (2025). Updated repository structure listing.
- Project status confirmed: **closed, well-characterised negative**. Three independent lines of evidence. Protein-binder route is not viable; transcript-level (siRNA/ASO) is the correct modality for AP2A1-selective intervention.

## 2025 — Initial project (see git log)

- Phase 1: Design 180 pipeline (ProteinMPNN / ESMFold / LightDock); AF3 negative result (ipTM 0.14–0.15).
- Phase 2: bioPROTAC pivot; BindCraft binder to AP2A1 ear (ipTM 0.92–0.93 AF3 validation); ternary modeling; AP2A2 selectivity failure (ipTM 0.93 cross-reactive).
