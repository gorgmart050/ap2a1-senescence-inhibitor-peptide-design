#!/usr/bin/env bash
# Input: ./data/esmfold_structures/ (Top 10 gefiltert nach pLDDT)
# Output: ./data/docking_results/

echo "=== Schritt 3: LightDocking (Top 10 Kandidaten) ==="
mkdir -p ./data/docking_results

# Target-Struktur definieren
TARGET="../data/AP2A1_target_structure.pdb"

# Schleife für die Top 10 pLDDT-Kandidaten
for i in {1..10}
do
    RECEPTOR="./data/esmfold_structures/peptide_${i}.pdb"
    echo "Starte Docking-Setup für Kandidat ${i}..."
    
    # LightDock Setup-Befehl (Pfade anpassen falls nötig)
    lightdock3_setup.py $TARGET $RECEPTOR --noxtal --glowworm 100
    
    # Simulation ausführen (z.B. 100 Steps)
    lightdock3.py setup.json 100 -c 4
    
    # Ergebnisse wegsichern
    mv swarms/ ./data/docking_results/swarm_candidate_${i}
done

echo "Docking für die Top 10 abgeschlossen."
