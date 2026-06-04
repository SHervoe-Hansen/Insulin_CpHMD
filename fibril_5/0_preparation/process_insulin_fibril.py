import string
import sys
from Bio.PDB import PDBParser, PDBIO, Structure, Model
import mdtraj as md
import numpy as np
from itertools import combinations

def reorder_chains(input_pdb, output_pdb):
    parser = PDBParser(QUIET=True)
    structure = parser.get_structure("fibril", input_pdb)

    # Collect chains by ID
    chains = {chain.id: chain for model in structure for chain in model}

    # Create new structure with interleaved capital+lowercase pairs
    new_structure = Structure.Structure("reordered")
    model = Model.Model(0)
    new_structure.add(model)

    for upper in string.ascii_uppercase:
        lower = upper.lower()
        if upper in chains:
            model.add(chains[upper])
            if lower in chains:
                model.add(chains[lower])
            else:
                print(f"⚠️ Warning: Lowercase chain '{lower}' not found for monomer '{upper}'")
        elif lower in chains:
            print(f"⚠️ Warning: Capital chain '{upper}' not found for monomer '{lower}', adding lowercase only.")
            model.add(chains[lower])

    # Write to file
    io = PDBIO()
    io.set_structure(new_structure)
    io.save(output_pdb)
    print(f"✅ Reordered PDB saved to: {output_pdb}")

def find_disulfide_bonds(pdb_file):
    pdb = md.load_pdb(pdb_file)
    start_index = pdb.topology.residue(0).resSeq

    # Map MDTraj residues to tleap-style numbering
    residue_map = {}
    for i, residue in enumerate(pdb.topology.residues):
        tleap_index = start_index + i
        residue_map[residue] = tleap_index

    # Collect all SG atoms from CYS or CYX
    sg_atoms = [(atom.index, atom.residue) for atom in pdb.topology.atoms
                if atom.name == "SG" and atom.residue.name in ["CYS", "CYX"]]

    print(f"\n🔬 Found {len(sg_atoms)} cysteine SG atoms.")

    # Detect disulfide pairs under 2.2 Å
    disulfide_pairs = []
    for (idx1, res1), (idx2, res2) in combinations(sg_atoms, 2):
        dist = md.compute_distances(pdb, [[idx1, idx2]])[0][0]  # in nm
        if dist < 0.22:
            disulfide_pairs.append((res1, res2, dist))

    print(f"🔗 Found {len(disulfide_pairs)} potential disulfide bonds:\n")
    for res1, res2, dist in disulfide_pairs:
        idx1 = residue_map[res1]
        idx2 = residue_map[res2]
        print(f"bond mol.{idx1}.SG mol.{idx2}.SG  # {res1} ↔ {res2}, dist = {dist*10:.2f} Å")

if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description="Reorder insulin fibril chains and detect disulfide bonds.")
    parser.add_argument("input_pdb", help="Input PDB file")
    parser.add_argument("output_pdb", help="Output reordered PDB file")
    parser.add_argument("--disulfides", action="store_true", help="Detect disulfide bonds and print tleap bond commands")

    args = parser.parse_args()

    reorder_chains(args.input_pdb, args.output_pdb)

    if args.disulfides:
        find_disulfide_bonds(args.output_pdb)

