# Fibril simulation: truncated insulin fibril (1-mer)

This directory contains molecular dynamics simulations of a **truncated insulin fibril consisting of a single fibril segment (1-mer)**. The fibril fragment is **capped at the termini** to avoid artificial end effects caused by truncation of the protofilament.

The system is used to investigate **pH-dependent stabilizing interactions within fibrillar insulin structures**.

### Protonation states

Constant protonation states were assigned for the following titratable residues:

- **HIP** – protonated histidine
- **AS4** – protonated aspartic acid
- **GL4** – protonated glutamic acid
- **LYS** – lysine
- **TYR** – tyrosine

These residues were selected for titration analysis in order to study the effect of pH on fibril stability.

---

### Directory layout

- `0_preparation/`  
  System preparation including structure processing, protonation assignment, and topology generation.

- `1_minimization/`  
  Energy minimization of the system.

- `2_heating/`  
  Gradual heating of the system to the target simulation temperature.

- `3_equilibration/`  
  Equilibration of the system prior to production simulations.

- `4_production/`  
  Production molecular dynamics trajectories used for analysis.

- `5_analysis/`  
  Analysis scripts and intermediate analysis outputs.

- `data/`  
  Processed data extracted from the simulations.

---

### Notes

The simulation workflow follows a standard molecular dynamics protocol:

preparation → minimization → heating → equilibration → production → analysis

