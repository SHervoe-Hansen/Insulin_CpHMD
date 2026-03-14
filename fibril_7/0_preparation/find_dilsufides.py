import mdtraj as md
import numpy as np
from itertools import combinations

# Load your pdb file
pdb = md.load_pdb('fibril_A.pdb')

# Get the starting residue index from the first residue
start_index = pdb.topology.residue(0).resSeq

# Map each residue to tleap-style index (start_index, start_index + 1, ...)
residue_map = {}
for i, residue in enumerate(pdb.topology.residues):
    tleap_index = start_index + i
    residue_map[residue] = tleap_index

# Select all SG atoms in CYS or CYX residues
sg_atoms = [(atom.index, atom.residue) for atom in pdb.topology.atoms
            if atom.name == "SG" and atom.residue.name in ["CYS", "CYX"]]

print(f"Found {len(sg_atoms)} cysteine SG atoms.")

# Find pairs of SG atoms closer than 2.2 Å (0.22 nm)
disulfide_pairs = []
for (idx1, res1), (idx2, res2) in combinations(sg_atoms, 2):
    dist = md.compute_distances(pdb, [[idx1, idx2]])[0][0]  # distance in nm
    if dist < 0.22:
        disulfide_pairs.append((res1, res2, dist))

print(f"Found {len(disulfide_pairs)} potential disulfide bonds.\n")

# Print tleap-style bond commands using residue_map
for res1, res2, dist in disulfide_pairs:
    tleap_idx1 = residue_map[res1]
    tleap_idx2 = residue_map[res2]
    print(f"bond mol.{tleap_idx1}.SG mol.{tleap_idx2}.SG  # {res1} ↔ {res2}, dist = {dist*10:.2f} Å")
