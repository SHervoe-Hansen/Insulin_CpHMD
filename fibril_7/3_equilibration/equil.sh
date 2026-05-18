#!/bin/bash

export AMBERHOME=/data9/stefan/amber24
source /data9/stefan/amber24/amber.sh

# During volume relaxation the volume will change a lot causing an error on GPU code, therefore run CPU code
mpirun -np 64 pmemd.MPI -O -i equil.mdin -p ../0_preparation/insulin_fibril.explicit.parm7 -c ../2_heating/insulin_fibril.heat.rst7 -cpin ../0_preparation/insulin_fibril.cpin -ref ../2_heating/insulin_fibril.heat.rst7 -o insulin_fibril.equil.mdout -r insulin_fibril.equil.rst7 -x insulin_fibril.equil.nc -cprestrt insulin_fibril.equil.cpin -cpout insulin_fibril.equil.cpout

