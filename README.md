# Electronic Notebook: pH-Dependent Stability and Thermodynamics of Insulin's Native and Fibril States

[![License: BSD 3-Clause](https://img.shields.io/badge/License-BSD%203--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.19027365.svg)](https://doi.org/10.5281/zenodo.19027365)

This repository contains supporting information, molecular dynamics (MD) simulation data, and analysis scripts accompanying the following scientific manuscripts by *Hervø-Hansen et al.*:

1. **Characterization of the pH-Dependent Stabilizing Forces of Insulin's Native and Fibril States** *ACS Physical Chemistry Au*, 2026 (Accepted).
2. **pH-Dependent Free Energies of Insulin Fibrillation from Protonation Ensemble Statistics** 2026 (Under preparation / submitted).
*This README will be updated with the journal reference and DOI once available.*

---

## Repository Layout

### Data Directories
* `monomer/` — Simulation data and trajectories for the insulin monomer system.
* `fibril_1/` to `fibril_8/` — Simulation data for insulin fibril fragments ranging from 1-mer to 8-mer lengths.
* `Figures/` — Publication-ready figures generated during data analysis.

### Jupyter Notebooks
* `Simulations.ipynb` — Detailed workflow describing how the molecular dynamics simulations were prepared, configured, and executed.
* `Analysis_monomer.ipynb` — Analysis of the insulin monomer simulations.
* `Analysis_fibril_1mer.ipynb` — Analysis of the fibril 1-mer system.
* `Analysis_fibril_3mer.ipynb` — Analysis of the fibril 3-mer system.
* `Analysis_fibril_7mer.ipynb` — Analysis of the fibril 7-mer system.
* `Analysis_fibrillation_thermodynamics.ipynb` — Thermodynamics analysis evaluating pH-dependent free energies from protonation ensemble statistics.

### Miscellaneous
* `LICENSE` — The text of the BSD 3-Clause License.
* `README.md` — This file.

---

## License

This project is licensed under the [BSD 3-Clause License](https://opensource.org/licenses/BSD-3-Clause).
