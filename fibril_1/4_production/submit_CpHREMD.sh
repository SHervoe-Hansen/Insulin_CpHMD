#!/bin/bash
#PBS -N amber_repex
#PBS -l nodes=1:ppn=36:nu-g01
#PBS -o run.out
#PBS -e run.err

cd /data9/stefan/fibril_1/4_production

source ~/.bashrc
source ~/.bash_profile

conda activate amberbuild

export AMBERHOME=/data9/stefan/amber24
source /data9/stefan/amber24/amber.sh

export CUDA_VISIBLE_DEVICES=0,1

mpiexec -np 28 pmemd.cuda.MPI -ng 28 -groupfile groupfile -rem 4 -remlog pHremd.log

