#!/bin/bash
#------ qsub options --------#
#PBS -q regular-g
#PBS -l select=28:mpiprocs=1
#PBS -l walltime=48:00:00
#PBS -W group_list=hp260036
#PBS -j oe

#------- Environment -------#
cd /home/u48000/work/fibril_2/4_production
export OMP_NUM_THREADS=1

source ~/.bashrc
source ~/.bash_profile

module load cuda/12.8
module load cmake

export AMBERHOME=/data9/stefan/amber24
source /data9/stefan/amber24/amber.sh

#------- Run -------#
mpiexec -np 28 pmemd.cuda.MPI -ng 28 -groupfile groupfile -rem 4 -remlog pHremd.log

