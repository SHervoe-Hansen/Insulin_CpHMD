#!/bin/bash
## FLOW
#PJM -L rscunit=cx
#PJM -L rscgrp=cx-share
#PJM -L gpu=1
#PJM -L elapse=168:00:00
#PJM -o run.out
#PJM -e run.err

module purge
module load gcc/11.3.0 openmpi/4.1.5 cuda/12.4.1

export AMBERHOME=/home/z44785r/amber24
source /home/z44785r/amber24/amber.sh

# During volume relaxation the volume will change a lot causing an error on GPU code, therefore run CPU code
mpirun -np 10 pmemd.MPI -O -i equil.mdin -p ../0_preparation/insulin.explicit.parm7 -c ../2_heating/insulin.heat.rst7 -cpin ../0_preparation/insulin.cpin -o insulin.equil.mdout -r insulin.equil.rst7 -x insulin.equil.nc -cprestrt insulin.equil.cpin -cpout insulin.equil.cpout

