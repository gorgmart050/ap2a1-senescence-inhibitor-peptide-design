#!/usr/bin/env bash
# Input: ./data/esmfold_structures/ (Top 10 gefiltert nach pLDDT)
# Output: ./data/docking_results/

set -euo pipefail

echo "=== Schritt 3: LightDocking (Top 10 Kandidaten) ==="

TARGET="./data/AP2A1_target_structure.pdb"
STRUCTURES_DIR="./data/esmfold_structures"
RESULTS_DIR="./data/docking_results"
mkdir -p "$RESULTS_DIR"

if [ ! -f "$TARGET" ]; then
    echo "Fehler: Target-Struktur $TARGET nicht gefunden."
    exit 1
fi

for i in {1..10}
do
    LIGAND="$STRUCTURES_DIR/peptide_${i}.pdb"
    if [ ! -f "$LIGAND" ]; then
        echo "Warnung: $LIGAND fehlt, überspringe..."
        continue
    fi

    echo "Starte Docking-Setup für Kandidat ${i}..."
    RUN_DIR="./docking_run_${i}"
    mkdir -p "$RUN_DIR"
    cp "$TARGET" "$RUN_DIR/"
    cp "$LIGAND" "$RUN_DIR/"

    pushd "$RUN_DIR" > /dev/null

    lightdock3_setup.py AP2A1_target_structure.pdb "peptide_${i}.pdb" -s 25 -g 200 --noxt --noh

    lightdock3.py setup.json 100 -c 4 -s dfire

    # Konformationen für alle Swarms generieren
    for swarm_dir in swarm_*/; do
        lgd_generate_conformations.py setup.json "$swarm_dir" 100
    done

    lgd_cluster_binder.py setup.json

    # Bestes Modell sichern
    BEST=$(ls swarm_*/lightdock_*.pdb 2>/dev/null | head -1)
    if [ -n "$BEST" ]; then
        mkdir -p "../$RESULTS_DIR/swarm_candidate_${i}"
        cp "$BEST" "../$RESULTS_DIR/swarm_candidate_${i}/best_pose.pdb"
    else
        echo "Warnung: Kein Ergebnis für Kandidat ${i}"
    fi

    popd > /dev/null
    rm -rf "$RUN_DIR"

    echo "Kandidat ${i} abgeschlossen."
done

echo "Docking für die Top 10 abgeschlossen. Ergebnisse in $RESULTS_DIR/"
