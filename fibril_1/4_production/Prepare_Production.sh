#!/bin/sh
parm="../0_preparation/insulin_fibril.explicit.parm7"
cpin="../0_preparation/insulin_fibril.cpin"
beginstr="../3_equilibration/insulin_fibril.equil.rst7"
workdir=$(pwd)

rm groupfile
Nrep=0    
for pH in 0.0 0.5 1.0 1.5 2.0 2.5 3.0 3.5 4.0 4.5 5.0 5.5 6.0 6.5 7.0 7.5 8.0 8.5 9.0 9.5 10.0 10.5 11.0 11.5 12.0 12.5 13.0 13.5
do          
Nrep=`expr $Nrep + 1`
dir=pH${pH}
echo $i $dir
mkdir $dir

cp md_pH_template_NVT.mdin ${dir}/pH_${pH}.mdin
perl -pi -e"s/PH/${pH}/" ${dir}/pH_${pH}.mdin

cat <<EOF >>groupfile
# pH ${pH}
-O -i ${dir}/pH_${pH}.mdin -p $parm -c $beginstr -cpin $cpin -ref $beginstr -o ${dir}/insulin_fibril.pHREMD.mdout -cpout ${dir}/insulin_fibril.pHREMD.cpout -cprestrt ${dir}/insulin_fibril.pHREMD.cpin -r ${dir}/insulin_fibril.pHREMD.rst7 -inf ${dir}/insulin_fibril.pHREMD.mdinfo -x ${dir}/insulin_fibril.pHREMD.nc
EOF
done


cat <<EOF >submit_CpHREMD.sh
#!/bin/bash
#PBS -N amber_repex
#PBS -l nodes=1:ppn=36:nu-g01
#PBS -o run.out
#PBS -e run.err

cd $workdir

source ~/.bashrc
source ~/.bash_profile

conda activate amberbuild

export AMBERHOME=/data9/stefan/amber24
source /data9/stefan/amber24/amber.sh

export CUDA_VISIBLE_DEVICES=0,1

mpiexec -np $Nrep pmemd.cuda.MPI -ng $Nrep -groupfile groupfile -rem 4 -remlog pHremd.log

EOF

chmod u+x submit_CpHREMD.sh

