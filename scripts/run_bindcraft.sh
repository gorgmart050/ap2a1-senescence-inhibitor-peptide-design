#!/usr/bin/env bash
# run_bindcraft.sh — Phase 2: BindCraft binder design vs the AP2A1 ear domain
#
# Environment (as run):
#   FreeBindCraft (PyRosetta-free fork): https://github.com/cytokineking/FreeBindCraft
#   conda env: BindCraft | CUDA 12.4 | RTX 4060 laptop, 8 GB VRAM | WSL2/Ubuntu
#   GPU check:  python -c "import jax; print(jax.devices())"   # must list a gpu
#
# Target: human AP2A1 ear (residues 735-977) from AlphaFold AF-O95782-F1 v6
#         -> data/AP2A1_ear_human.pdb
# Settings: data/AP2A1ear_target.json
#
# NOTE: adjust the absolute paths below to your own checkout.

set -euo pipefail
cd ~/FreeBindCraft

# --- 8 GB VRAM fix: stops JAX preallocation OOM on the RTX 4060 ---
export XLA_PYTHON_CLIENT_PREALLOCATE=false
export XLA_PYTHON_CLIENT_ALLOCATOR=platform

# --- run ---
python -u ./bindcraft.py \
  --settings  '/home/georg/AP2A1/AP2A1ear_target.json' \
  --filters   './settings_filters/default_filters.json' \
  --advanced  './settings_advanced/default_4stage_multimer.json' \
  --no-pyrosetta

# Resume: re-run the exact same command — BindCraft continues in design_path
# and keeps already-accepted designs.
