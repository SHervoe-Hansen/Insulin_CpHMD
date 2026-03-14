#!/bin/bash
## FLOW
#PJM -L rscunit=cx
#PJM -L rscgrp=cx-single
#PJM -L node=1
#PJM --mpi proc=24
#PJM -L elapse=336:00:00
#PJM -o run.out
#PJM -e run.err

module purge
module load gcc/11.3.0 openmpi/4.1.5 cuda/12.4.1

export AMBERHOME=/home/z44785r/amber24
source /home/z44785r/amber24/amber.sh

export CUDA_VISIBLE_DEVICES=0,1,2,3

mpiexec -np 24 pmemd.cuda.MPI -ng 24 -groupfile groupfile -rem 4 -remlog pHremd.log

