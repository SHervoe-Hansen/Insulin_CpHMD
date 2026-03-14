# 0_preparation

This directory contains the steps required to prepare the insulin fibril system for constant pH molecular dynamics (CpHMD) simulations using Amber.

The preparation consists of:
1. Modifying residue names for titratable residues
2. Reordering the fibril chains and identifying disulfide bonds
3. Generating topology and coordinate files
4. Creating the CpHMD input file (CPIN)

---

## Step 1 – Modify residue names of titratable residues

Modify the residue names of residues that should be allowed to titrate during the CpHMD simulations.

Note that Amber currently does **not allow titration of ARG, N-terminal residues, or C-terminal residues**.

Example command:

```bash
perl -pi -e 's/HIS/HIP/,s/ASP/AS4/,s/GLU/GL4/,s/CYS/CYX/' 8SBD_no_H_clean.pdb
```

---

## Step 2 – Reorder fibril chains and identify disulfide bonds

Reorder the insulin chains and identify all disulfide bonds using the provided script:

```bash
python process_insulin_fibril.py fibril_A_capped.pdb fibril_A_capped_reordered.pdb --disulfides
```

---

## Step 3 – Generate topology and coordinate files

Prepare the Amber topology (`prmtop` / `parm7`) and input coordinate (`inpcrd`) files using `tleap`:

```bash
tleap -f tleap.in
```

---

## Step 4 – Create the CPIN file

Generate the CpHMD protonation input file using `cpinutil.py`:

```bash
cpinutil.py -resnames HIP GL4 -p insulin_fibril.parm7 -o insulin_fibril.cpin -op insulin_fibril.explicit.parm7
```

This command generates the CPIN file required for constant pH simulations.

