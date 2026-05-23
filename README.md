# AP2A1 Senescence Peptide Design Pipeline

This repository contains the full computational pipeline and results for designing de novo peptide inhibitors targeting the **AP2A1 platform site** to modulate cellular senescence.

The framework is optimized for consumer-grade hardware, utilizing a strict cascade filtering strategy to process candidates efficiently: generating 10,000 sequences, folding the top 200, and performing full-atom docking for the top 10 leads.

---

## 📁 Repository Structure

```text
ap2a1-senescence-peptide-design/
├── data/
│   ├── AP2A1_target_structure.pdb   # Original AP2A1 target structure/backbone
│   ├── top_200_redesigned.fasta     # Output of Step 1 (Top 200 ProteinMPNN sequences)
│   └── esmfold_structures/          # Output of Step 2 (200 folded PDB structures)
├── scripts/
│   ├── step1_proteinmpnn.py         # Sequence generation and initial log-likelihood filtering
│   ├── step2_esmfold.py             # Local GPU-accelerated folding of the top 200 candidates
│   └── step3_lightdock.sh           # Automated LightDock routing for the top 10 pLDDT leads
├── results/
│   ├── Design180_sequence.txt       # Amino acid sequence of the selected champion lead
│   ├── Design180_docked_complex.pdb # Structural PDB model of the best binding pose
│   └── Design180_binding_site.jpg   # Visual interaction analysis of the interface
└── README.md                        # Project documentation and setup guide

---

## 🛠️ Requirements & Installation

To run this pipeline locally, you need a Linux/macOS environment (or WSL2 on Windows) equipped with an NVIDIA GPU configured for CUDA to execute the ESMFold step efficiently.

### 1. Clone the Repository
git clone https://github.com/YOUR_USERNAME/ap2a1-senescence-peptide-design.git
cd ap2a1-senescence-peptide-design

### 2. Set Up Environment & Dependencies
We recommend using a Python Virtual Environment or Conda:

# Create and activate python environment
python3 -m venv venv
source venv/bin/activate

# Install PyTorch with CUDA support (adjust index according to your CUDA toolkit)
pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118

# Install ESMFold and required bio-libraries
pip3 install fair-esm biopython scipy

# Install LightDock
pip3 install lightdock

---

## 🚀 How to Run the Pipeline

### Step 1: Sequence Generation (ProteinMPNN)
Generates 10,000 de novo sequences conditioned on the AP2A1 structural constraints and extracts the top 200 candidates based on the lowest log-likelihood score.

Command:
python3 scripts/step1_proteinmpnn.py

Output generated: ./data/top_200_redesigned.fasta

### Step 2: Structural Folding (ESMFold)
Folds the selected 200 candidates locally utilizing your GPU.

Command:
python3 scripts/step2_esmfold.py

Output generated: 200 individual structural PDBs inside ./data/esmfold_structures/

### Step 3: Targeted Docking (LightDock)
Filters the folded structures by their pLDDT score (internal structural stability) and runs automated full-atom docking for the top 10 leads against the AP2A1 platform site.

Command:
bash scripts/step3_lightdock.sh

Output generated: Simulation data stored under ./data/docking_results/

---

## 📊 Reference Results ("Design 180")

The repository provides the raw structural data for our top-tier lead candidate, "Design 180", which emerged as the superior binder from our cascade.

* Target Site: AP2A1 Platform Site
* Lead Candidate length: 356 AA
* Best Binding Score: -25.730 (LightDock Scoring Function)

Users can inspect the ready-to-use complex in ./results/Design180_docked_complex.pdb to review its thermodynamic and geometric complementarity to the target site.

---

## 💡 About this Project

This repository represents an independent research framework conducted as an AI-driven pilot framework. The complete proteomic and structural automation pipeline was implemented in leisure time, utilizing Google's Gemini as a pair-programmer to tackle structural biology scripting and orchestration workflows.

Note: This data serves as a computational pilot study. I am actively sharing these datasets with international academic partners to evaluate the biological plausibility of Design 180 in vitro.

## 📜 License
This project is licensed under the MIT License.
