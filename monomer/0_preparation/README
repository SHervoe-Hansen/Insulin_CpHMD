# 0_preparation

This directory contains the steps required to prepare the insulin system for constant pH molecular dynamics (CpHMD) simulations using Amber.

The preparation consists of:
1. Modifying residue names for titratable residues
2. Generating topology and coordinate files
3. Creating the CpHMD input file (CPIN)

---

## Step 1 – Modify residue names of titratable residues

Modify the residue names of residues that should be allowed to titrate during the CpHMD simulations.

Note that Amber currently does **not allow titration of ARG, N-terminal residues, or C-terminal residues**.

Example command:

```bash
perl -pi -e 's/HIS/HIP/,s/ASP/AS4/,s/GLU/GL4/,s/CYS/CYX/' EXG_WT_Fixed.pdb
```

Alternatively, the structure can be processed using `pdb4amber`:

```bash
pdb4amber -i 3i40.pdb -o insulin.pdb --dry --constantph
```

---

## Step 2 – Generate topology and coordinate files

Prepare the Amber topology (`prmtop` / `parm7`) and input coordinate (`inpcrd`) files using `tleap`:

```bash
tleap -f tleap.in
```

---

## Step 3 – Create the CPIN file

Generate the CpHMD protonation input file using `cpinutil.py`:

```bash
cpinutil.py -resnames HIP AS4 GL4 LYS TYR -p insulin.parm7 -o insulin.cpin -op insulin.explicit.parm7
```

This command generates the CPIN file required for constant pH simulations.

