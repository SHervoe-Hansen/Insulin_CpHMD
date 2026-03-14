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

pmemd.cuda -O -i heat.mdin -c ../1_minimization/insulin_fibril.min.rst7 -p ../0_preparation/insulin_fibril.explicit.parm7 -ref ../1_minimization/insulin_fibril.min.rst7 -cpin ../0_preparation/insulin_fibril.cpin -o insulin_fibril.heat.mdout -r insulin_fibril.heat.rst7 -x insulin_fibril.heat.nc

#sander -O -i heat.mdin -c ../1_minimization/insulin_fibril.min.rst7 -p ../0_preparation/insulin_fibril.explicit.parm7 -ref ../1_minimization/insulin_fibril.min.rst7 -cpin ../0_preparation/insulin_fibril.cpin -o insulin_fibril.heat.mdout -r insulin_fibril.heat.rst7 -x insulin_fibril.heat.nc
