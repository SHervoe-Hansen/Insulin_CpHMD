#!/bin/sh
parm="../0_preparation/insulin.explicit.parm7"
cpin="../0_preparation/insulin.cpin"
beginstr="../3_equilibration/insulin.equil.rst7"

rm groupfile
Nrep=0
for pH in 2.0 2.5 3.0 3.5 4.0 4.5 5.0 5.5 6.0 6.5 7.0 7.5 8.0 8.5 9.0 9.5 10.0 10.5 11.0 11.5 12.0 12.5 13.0 13.5
do
Nrep=`expr $Nrep + 1`
dir=pH${pH}
echo $i $dir
mkdir $dir

cp md_pH_template_NVT.mdin ${dir}/pH_${pH}.mdin
perl -pi -e"s/PH/${pH}/" ${dir}/pH_${pH}.mdin

cat <<EOF >>groupfile
# pH ${pH}
-O -i ${dir}/pH_${pH}.mdin -p $parm -c $beginstr -cpin $cpin -o ${dir}/insulin.pHREMD.mdout -cpout ${dir}/insulin.pHREMD.cpout -cprestrt ${dir}/insulin.pHREMD.cpin -r ${dir}/insulin.pHREMD.rst7 -inf ${dir}/insulin.pHREMD.mdinfo -x ${dir}/insulin.pHREMD.nc
EOF
done


cat <<EOF >submit_CpHREMD.sh
#!/bin/bash
## FLOW
#PJM -L rscunit=cx
#PJM -L rscgrp=cx-single
#PJM -L node=1
#PJM --mpi proc=$Nrep
#PJM -L elapse=336:00:00
#PJM -o run.out
#PJM -e run.err

module purge
module load gcc/11.3.0 openmpi/4.1.5 cuda/12.4.1

export AMBERHOME=/home/z44785r/amber24
source /home/z44785r/amber24/amber.sh

export CUDA_VISIBLE_DEVICES=0,1,2,3

mpiexec -np $Nrep pmemd.cuda.MPI -ng $Nrep -groupfile groupfile -rem 4 -remlog pHremd.log

EOF

chmod u+x submit_CpHREMD.sh

