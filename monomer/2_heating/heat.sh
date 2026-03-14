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

pmemd.cuda -O -i heat.mdin -c ../1_minimization/insulin.min.rst7 -p ../0_preparation/insulin.explicit.parm7 -cpin ../0_preparation/insulin.cpin -o insulin.heat.mdout -r insulin.heat.rst7 -x insulin.heat.nc


