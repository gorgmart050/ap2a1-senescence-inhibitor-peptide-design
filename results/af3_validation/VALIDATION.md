# Independent validation - AlphaFold3 complex prediction

## Summary

Design 180 (the LightDock champion from the original pipeline) was re-evaluated
by predicting the **AP2A1 + design 180 complex** with AlphaFold3, a model fully
independent of the original pipeline (ProteinMPNN -> ESMFold -> LightDock).

**Result: the binding interaction is not supported.**

| Metric | Value (mean over 5 models) | Interpretation |
|--------|---------------------------|----------------|
| Interface ipTM | 0.15 | No reliable inter-chain interaction (threshold for confidence >= 0.6+) |
| Inter-chain PAE (min) | ~28 A | Model has no defined relative orientation of the two chains |
| pTM chain A (AP2A1) | 0.55 | AP2A1 folds reasonably on its own |
| pTM chain B (design 180) | 0.87 | The designed protein folds well on its own |
| has_clash | 0.0 | No steric clashes |

All 5 AF3 models returned ipTM 0.14-0.15 with no outliers, indicating the
negative result is consistent rather than a sampling artifact.

## Interpretation

Each chain folds well in isolation (high intra-chain pTM, low intra-chain PAE),
but AlphaFold3 predicts **no preferred interaction** between AP2A1 and design 180.
The original LightDock score (-25.730) reflects a forced docking pose; rigid-body
docking places a complex regardless of whether a favorable interaction exists.
Without the docking constraint, an independent structure-prediction model does
not reproduce the binding.

This is consistent with current literature reporting that in-silico docking and
folding metrics correlate poorly with real binding affinity, and that de novo
binder candidates frequently fail independent validation.

## Honest conclusion

Design 180 should **not** be presented as a validated AP2A1 binder. This negative
result is reported openly as part of a complete, self-critical methodology. The
value of this entry is methodological: it documents that independent cross-checking
was performed and what it showed.

## Reproduction

- Tool: AlphaFold3 Server (alphafoldserver.com)
- Input: AP2A1 (chain A) + design 180, 364 aa (chain B), as two separate protein entities
- Seed: auto, 5 models, 10 recycles
- Raw outputs: see the JSON files in this folder