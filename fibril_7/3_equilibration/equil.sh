#!/bin/bash
## FLOW
#PJM -L rscunit=cx
#PJM -L rscgrp=cx-share
#PJM -L gpu=1
#PJM -L elapse=168:00:00
#PJM -o run.out
#PJM -e run.err

source ~/.bashrc
source ~/.bash_profile

conda activate amberbuild

export AMBERHOME=/data9/stefan/amber24
source /data9/stefan/amber24/amber.sh

export CUDA_VISIBLE_DEVICES=0,1

# During volume relaxation the volume will change a lot causing an error on GPU code, therefore run CPU code
mpirun -np 36 pmemd.MPI -O -i equil.mdin -p ../0_preparation/insulin_fibril.explicit.parm7 -c ../2_heating/insulin_fibril.heat.rst7 -cpin ../0_preparation/insulin_fibril.cpin -ref ../2_heating/insulin_fibril.heat.rst7 -o insulin_fibril.equil.mdout -r insulin_fibril.equil.rst7 -x insulin_fibril.equil.nc -cprestrt insulin_fibril.equil.cpin -cpout insulin_fibril.equil.cpout

