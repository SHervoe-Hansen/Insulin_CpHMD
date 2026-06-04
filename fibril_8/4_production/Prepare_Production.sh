#!/bin/sh
parm="../0_preparation/insulin_fibril.explicit.parm7"
cpin="../0_preparation/insulin_fibril.cpin"
beginstr="../3_equilibration/insulin_fibril.equil.rst7"

Ngpu=4
Ntasks=$((Ngpu*10))

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
-O -i ${dir}/pH_${pH}.mdin -p $parm -c $beginstr -ref $beginstr -cpin $cpin -o ${dir}/insulin_fibril.pHREMD.mdout -cpout ${dir}/insulin_fibril.pHREMD.cpout -cprestrt ${dir}/insulin_fibril.pHREMD.cpin -r ${dir}/insulin_fibril.pHREMD.rst7 -inf ${dir}/insulin_fibril.pHREMD.mdinfo -x ${dir}/insulin_fibril.pHREMD.nc
EOF
done


cat <<EOF >submit_CpHREMD.sh
#!/bin/bash
#------ qsub options --------#
#PBS -q regular-g
#PBS -l select=28:mpiprocs=1
#PBS -l walltime=48:00:00
#PBS -W group_list=hp260036
#PBS -j oe

#------- Environment -------#
cd ${PBS_O_WORKDIR}

export OMP_NUM_THREADS=1

source ~/.bashrc
source ~/.bash_profile

module load cuda/12.8
module load cmake

export AMBERHOME=/data9/stefan/amber24
source /data9/stefan/amber24/amber.sh

#------- Run -------#
mpiexec -np $Nrep pmemd.cuda.MPI -ng $Nrep -groupfile groupfile -rem 4 -remlog pHremd.log

EOF

chmod u+x submit_CpHREMD.sh

