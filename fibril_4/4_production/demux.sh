#!/bin/bash

# Define pH values to extract
pH_values=(0.0 0.5 1.0 1.5 2.0 2.5 3.0 3.5 4.0 4.5 5.0 5.5 6.0 6.5 7.0 7.5 8.0 8.5 9.0 9.5 10.0 10.5 11.0 11.5 12.0 12.5 13.0 13.5)

# Create a temporary folder for unified replica naming
tmpdir="tmp_trajs_cpptraj"
mkdir -p "$tmpdir"

# Copy and rename all insulin.pHREMD.nc files to replica.nc.000, .001, etc.
i=0
for dir in pH*/; do
    cp "${dir}/insulin_fibril.pHREMD.nc" "$tmpdir/replica.nc.$(printf "%03d" $i)"
    ((i++))
done

# Move into the temp directory to run cpptraj
cd "$tmpdir" || exit 1

# Loop over pH values and extract frames for each
for pH in "${pH_values[@]}"; do
    outdir="../pH${pH}"
    mkdir -p "$outdir"

    cpptraj  <<EOF
parm ../../0_preparation/insulin_fibril.explicit.parm7
trajin replica.nc.000 1 last remdtraj remdtrajvalues ${pH}
strip :WAT
trajout ${outdir}/insulin_fibril.constant_pH${pH}.nc netcdf
run
quit
EOF
done

# Cleanup
cd ..
rm -rf "$tmpdir"

