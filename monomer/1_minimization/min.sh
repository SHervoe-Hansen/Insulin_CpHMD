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

pmemd.cuda -O -i min.mdin -p ../0_preparation/insulin.explicit.parm7 -c ../0_preparation/insulin.rst7 -o insulin.min.mdout -r insulin.min.rst7 -ref ../0_preparation/insulin.rst7 -cpin ../0_preparation/insulin.cpin

