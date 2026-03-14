#!/bin/bash
#PBS -N amber_repex
#PBS -l nodes=1:ppn=36:nu-g02
#PBS -o run.out
#PBS -e run.err

source ~/.bashrc
source ~/.bash_profile

conda activate amberbuild

export AMBERHOME=/data9/stefan/amber24
source /data9/stefan/amber24/amber.sh

export CUDA_VISIBLE_DEVICES=0,1

mpiexec -np 18 pmemd.cuda.MPI -ng 18 -groupfile groupfile -rem 4 -remlog pHremd.log

