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

pmemd.cuda -O -i min.mdin -p ../0_preparation/insulin_fibril.explicit.parm7 -c ../0_preparation/insulin_fibril.rst7 -o insulin_fibril.min.mdout -r insulin_fibril.min.rst7 -ref ../0_preparation/insulin_fibril.rst7 -cpin ../0_preparation/insulin_fibril.cpin

