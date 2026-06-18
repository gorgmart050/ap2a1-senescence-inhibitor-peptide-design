# AP2A1 Closure — Structural-Biology Rationale

**Status: project closed as a documented negative.**

This document is the structural-biology companion to the empirical negatives already in the
repository. It does **not** replace them — it explains *why*, independent of any single design run,
a selective protein binder / degrader for AP2A1 (and the integrin-β1 composite-epitope fallback) is
not a tractable approach. The reasoning rests entirely on the **published literature** cited below;
every reference was verified against CrossRef (title, authors, journal, volume, pages, DOI) before
this file was committed.

It is consistent with feedback from domain experts, but no private correspondence is reproduced
here; all points stand on the public record.

---

## Two distinct kinds of negative — keep them separate

| | What it shows | Where it lives |
|---|---|---|
| **Empirical negative** (design runs) | The actual BindCraft / AF3 attempts failed: pan-α-adaptin cross-reactivity (AP2A2 ipTM 0.93 = AP2A1), and 0 accepted designs across two selectivity-redesign runs (i_pAE wall), plus an underdetermined ternary geometry. | `README.md` §5–§8, `results/selectivity_redesign_negative.md`, `results/SUMMARY.md` |
| **Structural rationale** (this file) | *Independently of those runs*, the published structural biology of AP2 and integrin trafficking predicts that the approach cannot work in principle. | this document |

The two lines of evidence are independent and converge. The empirical runs could in principle have
been blamed on tooling, sampling, or hardware (RTX 4060, one backbone); the structural rationale
shows the failure is not a tooling artefact but a property of the biology.

---

## 1. AP2 is an obligate heterotetramer — "free, targetable AP2A1" is not a physiological species

The endocytic AP2 adaptor is a four-subunit complex (α / β2 / μ2 / σ2). Its crystal structure shows
the α-adaptin **trunk** packed into an extensively buried interface with β2 and σ2 to form the
"core," with μ2 docked on top — i.e. the subunits are structurally interdependent, not independent
folding units that happen to associate.

- Collins BM, McCoy AJ, Kent HM, Evans PR, Owen DJ. *Molecular Architecture and Functional Model of
  the Endocytic AP2 Complex.* **Cell 109(4):523–535 (2002).** DOI 10.1016/S0092-8674(02)00735-3.

**Consequence for this project.** The therapeutic premise implicitly treats AP2A1 as a free,
individually up-regulated, individually targetable protein. Structurally, the α subunit's trunk only
exists as part of the assembled tetramer; the appendage ("ear") domain we designed against hangs off
that core on a flexible linker but does not change the fact that the targetable entity in cells is
the **complex**, not an orphan α-adaptin monomer. A degrader that engages the α-ear would, if it did
anything, perturb the whole AP2 holocomplex — the central machine of clathrin-mediated endocytosis —
rather than selectively removing a stand-alone "AP2A1 protein." (This compounds the paralog problem
in §2/§4 below: AP2A2 forms the identical complex.)

---

## 2. The α-appendage reads DPF/DPW and FxDxF motifs — integrins do not carry these → no direct α-ear–integrin interface

The binder in this project targets the **α-appendage (ear)** domain. The natural ligands of that
domain are short linear motifs — **DPF/DPW** and **FxDxF** — presented by endocytic *accessory*
proteins (amphiphysin, Eps15, epsin, AP180, etc.), which bind two defined sites ("top" and "side")
on the appendage platform.

- Owen DJ, Vallis Y, Noble MEM, Hunter JB, Dafforn TR, Evans PR, McMahon HT. *A Structural
  Explanation for the Binding of Multiple Ligands by the α-Adaptin Appendage Domain.*
  **Cell 97(6):805–815 (1999).** DOI 10.1016/S0092-8674(00)80791-6.
- Praefcke GJK, Ford MGJ, Schmid EM, Olesen LE, Gallop JL, Peak-Chew S-Y, Vallis Y, Babu MM, Mills
  IG, McMahon HT. *Evolving nature of the AP2 α-appendage hub during clathrin-coated vesicle
  endocytosis.* **EMBO J 23(22):4371–4383 (2004).** DOI 10.1038/sj.emboj.7600445.

**Consequence for this project.** Integrin cytoplasmic tails do not present DPF/DPW or FxDxF motifs.
There is therefore no structural basis for a *direct* AP2A1(α-ear)–integrin contact of the kind a
"composite-epitope" binder would need to exploit. The designed binder occupies the accessory-protein
ligand surface — a surface that is (a) shared with AP2A2 (§4) and (b) not where integrin engages.

---

## 3. Integrin coupling to AP2 is routed through other subunits/adapters — any AP2A1–integrin-β1 link is indirect

The characterized routes by which integrins engage the AP2 machinery do **not** run through the
α-ear:

- A subset of integrin **α-chain** tails carry a **YxxΦ** motif that is read directly by the AP2
  **μ2** subunit — this, not the α-appendage, is the structurally defined integrin–AP2 contact.
  - De Franceschi N, Arjonen A, Elkhatib N, Denessiouk K, Wrobel AG, Wilson TA, Pouwels J, Montagnac
    G, Owen DJ, Ivaska J. *Selective integrin endocytosis is driven by interactions between the
    integrin α-chain and AP2.* **Nat Struct Mol Biol 23(2):172–179 (2016).** DOI 10.1038/nsmb.3161.
- Integrin **β-tail NPxY** motifs are read by **PTB-domain clathrin adapters (Dab2, Numb)**, which
  *themselves* dock onto AP2 — Dab2 binds the α-appendage via its own **DPF** motifs (i.e. as an
  accessory protein, per §2), bridging the integrin β-tail to the adaptor.
  - Review: Moreno-Layseca P, Icha J, Hamidi H, Ivaska J. *Integrin trafficking in cells and
    tissues.* **Nat Cell Biol 21(2):122–132 (2019).** DOI 10.1038/s41556-018-0223-z.

**Consequence for this project.** If AP2A1 and integrin β1 are functionally associated (as the
primary paper reports), the most parsimonious structural interpretation is an **indirect** linkage —
AP2A1-ear ↔ Dab2/Numb ↔ integrin-β1-tail — not a direct, designable AP2A1–integrin interface. A
composite-epitope binder built on a presumed direct contact has no structural target.

---

## 4. The primary evidence is colocalization / co-movement, not a defined binding interface → nothing to design against

The originating study reports AP2A1's senescence role through **colocalization and super-resolution
co-movement** of AP2A1 with integrin β1 along stress fibers — i.e. a *functional/spatial
association*. It does not report a co-crystal, cryo-EM, or even a successful co-IP that would define
a physical AP2A1–integrin **binding interface**.

- Chantachotikul P, Liu S, Furukawa K, Deguchi S. *AP2A1 modulates cell states between senescence
  and rejuvenation.* **Cellular Signalling 127:111616 (2025).** DOI 10.1016/j.cellsig.2025.111616.

**Consequence for this project.** A composite-epitope or interface-disruptor design needs an
experimentally defined interface as its template. None exists. Asking AlphaFold3 to model a
"AP2A1–integrin-β1 interface" from colocalization data only is asking it to *invent* an interface
that the experimental literature has not established — the resulting model would be a guess, not a
validation. This removes the last structural foothold for the protein-binder route.

---

## Strategic conclusion (final)

1. **Selective protein binder / degrader for AP2A1 — not viable.** The AP2A1 and AP2A2 ear surfaces
   are ~identical at the binder epitope; the divergent residues sit on a flat, undesignable patch
   (the empirical i_pAE wall); and AP2A1 is not a free monomer but a subunit of an obligate
   heterotetramer (§1).
2. **Integrin-β1 composite route — closed.** No defined interface exists (colocalization only, §4),
   the coupling is most likely indirect via Dab2/Numb (§3), and the heterotetramer constraint (§1)
   still applies.
3. **The selectivity lever for AP2A1 vs AP2A2 is at the expression / localization / RNA level**
   (siRNA, as in the primary study), **not on the protein surface.**
4. **Project status: closed as a documented negative** — the structural rationale is independently
   consistent with the published literature (and, without naming anyone or quoting anything, with
   expert feedback).

---

## References (all verified via CrossRef before commit)

1. Collins BM, McCoy AJ, Kent HM, Evans PR, Owen DJ. *Molecular Architecture and Functional Model of
   the Endocytic AP2 Complex.* Cell 109(4):523–535 (2002). DOI 10.1016/S0092-8674(02)00735-3.
2. Owen DJ, Vallis Y, Noble MEM, Hunter JB, Dafforn TR, Evans PR, McMahon HT. *A Structural
   Explanation for the Binding of Multiple Ligands by the α-Adaptin Appendage Domain.*
   Cell 97(6):805–815 (1999). DOI 10.1016/S0092-8674(00)80791-6.
3. Praefcke GJK, Ford MGJ, Schmid EM, Olesen LE, Gallop JL, Peak-Chew S-Y, Vallis Y, Babu MM, Mills
   IG, McMahon HT. *Evolving nature of the AP2 α-appendage hub during clathrin-coated vesicle
   endocytosis.* EMBO J 23(22):4371–4383 (2004). DOI 10.1038/sj.emboj.7600445.
4. De Franceschi N, Arjonen A, Elkhatib N, Denessiouk K, Wrobel AG, Wilson TA, Pouwels J, Montagnac
   G, Owen DJ, Ivaska J. *Selective integrin endocytosis is driven by interactions between the
   integrin α-chain and AP2.* Nat Struct Mol Biol 23(2):172–179 (2016). DOI 10.1038/nsmb.3161.
5. Moreno-Layseca P, Icha J, Hamidi H, Ivaska J. *Integrin trafficking in cells and tissues.*
   Nat Cell Biol 21(2):122–132 (2019). DOI 10.1038/s41556-018-0223-z.
6. Chantachotikul P, Liu S, Furukawa K, Deguchi S. *AP2A1 modulates cell states between senescence
   and rejuvenation.* Cellular Signalling 127:111616 (2025). DOI 10.1016/j.cellsig.2025.111616.
