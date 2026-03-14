from pymol import cmd
from pymol.cgo import *
import numpy as np

def draw_helix_dipole(
    selection="sele",
    name="dipole_arrow",
    length=5.0,
    thickness=1.0,
    color="blue red",
    offset=0.0
):
    """
    Draws a stylized dipole arrow for a helical segment in PyMOL using PCA on Cα atoms.

    This creates a CGO-based arrow aligned to the best-fit axis of the selected residues' 
    alpha-carbon positions. The arrow includes:
      - a cylindrical shaft and conical head (for dipole direction),
      - a disk at the negative end (for orientation),
      - automatic cleanup of previous CGO objects with the same name.

    Parameters
    ----------
    selection : str
        Atom selection string defining the helix (e.g., "chain A and resi 20-35").
        Only CA atoms are used for fitting the dipole axis.
    name : str
        Name of the CGO object to create (will overwrite any existing object of the same name).
    length : float
        Total length of the arrow in Ångströms.
    thickness : float
        Overall size scaling factor for shaft, cone, and disk radii.
    color : str
        Colors for the shaft and cone, as a space-separated string, e.g. "blue red".
    offset : float
        Shifts the entire arrow along the helix axis in Ångströms.
        Positive values move the arrow toward the positive dipole direction.

    Notes
    -----
    - Only the current trajectory frame is used.
    - Useful for visualizing the geometric dipole of α-helices or other regular structures.
    - Designed for use in PyMOL.

    Example
    -------
    # Draw a dipole from residues 20-35 on chain A, thicker and slightly offset toward the head:
    select myhelix, chain A and resi 20-35
    draw_helix_dipole selection=myhelix, name=helix_dipole, length=6.0, thickness=1.5, offset=1.0

    Author: Stefan Hervø-Hansen, 2025
    """

    # Validate inputs
    try:
        length = float(length)
        thickness = float(thickness)
        offset = float(offset)
    except ValueError:
        print("Error: 'length', 'thickness', and 'offset' must be numeric.")
        return

    if " " not in color:
        print("Error: color must be two space-separated color names (e.g., 'blue red').")
        return
    color1, color2 = color.split()
    rgb1 = list(cmd.get_color_tuple(color1))
    rgb2 = list(cmd.get_color_tuple(color2))

    # Remove old CGO object if exists
    if name in cmd.get_names("all"):
        cmd.delete(name)

    state = cmd.get_state()

    # Get coordinates of CA atoms in current frame
    model = cmd.get_model(f"({selection}) and name CA", state=state)
    if len(model.atom) < 2:
        print("Error: Not enough CA atoms found in selection.")
        return

    ca_coords = np.array([atom.coord for atom in model.atom])

    # PCA to find main axis
    center = np.mean(ca_coords, axis=0)
    coords_centered = ca_coords - center
    _, _, vh = np.linalg.svd(coords_centered)
    axis = vh[0]

    # Shift center along axis
    center_shifted = center + axis * offset

    # Arrow endpoints (centered at shifted center)
    start = center_shifted - axis * (length / 2)
    end = center_shifted + axis * (length / 2)

    # Geometry parameters
    shaft_radius = 0.2 * thickness
    head_radius = 0.35 * thickness
    head_length = 0.6 * thickness
    disk_radius = 0.4 * thickness
    disk_thickness = 0.05 * thickness

    cone_base = end - axis * head_length
    disk_top = start + axis * (disk_thickness / 2)
    disk_bottom = start - axis * (disk_thickness / 2)

    obj = [
        CYLINDER, *start, *cone_base, shaft_radius, *rgb1, *rgb2,
        CONE, *cone_base, *end, head_radius, 0.0, *rgb2, *rgb2, 1.0, 0.0,
        CYLINDER, *disk_bottom, *disk_top, disk_radius, *rgb1, *rgb1
    ]

    cmd.load_cgo(obj, name)

# Register in PyMOL
cmd.extend("draw_helix_dipole", draw_helix_dipole)

