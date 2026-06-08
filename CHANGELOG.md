# Changelog

## 2026-06-08 — Selectivity redesign negative + project closure

- Added `results/selectivity_redesign_negative.md`: documents two BindCraft selectivity redesign runs (ear_run_selective, ear_run_selective_v2), both producing zero accepted designs. Includes verified run statistics, backbone quality data, i_pAE wall interpretation, ternary geometry analysis, Deguchi 2025 mechanistic context, and strategic conclusion.
- Updated `README.md` §7: added "Follow-up: Selectivity Redesign" subsection summarising the two runs.
- Updated `README.md` §8: extended Honest Conclusion with explanation of why selectivity is an expression/RNA-level problem (not a protein-surface problem), referencing Deguchi et al. (2025). Updated repository structure listing.
- Project status confirmed: **closed, well-characterised negative**. Three independent lines of evidence. Protein-binder route is not viable; transcript-level (siRNA/ASO) is the correct modality for AP2A1-selective intervention.

## 2025 — Initial project (see git log)

- Phase 1: Design 180 pipeline (ProteinMPNN / ESMFold / LightDock); AF3 negative result (ipTM 0.14–0.15).
- Phase 2: bioPROTAC pivot; BindCraft binder to AP2A1 ear (ipTM 0.92–0.93 AF3 validation); ternary modeling; AP2A2 selectivity failure (ipTM 0.93 cross-reactive).
