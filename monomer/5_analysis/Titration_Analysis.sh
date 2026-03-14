#!/bin/sh

cpin=../0_preparation/insulin.cpin

rm reordered_cpouts.pH_* pH*
echo cphstats --fix-remd reordered_cpouts ../4_production/pH*/insulin.pHREMD.cpout 
cphstats --fix-remd reordered_cpouts ../4_production/pH*/insulin.pHREMD.cpout

echo "# 1    2" >titration_curves.dat
echo "# pH   Residue" >>titration_curves.dat
for pH in 2.0 2.5 3.0 3.5 4.0 4.5 5.0 5.5 6.0 6.5 7.0 7.5 8.0 8.5 9.0 9.5 10.0 10.5 11.0 11.5 12.0 12.5 13.0 13.5 
do
	pH_fmt=$(printf "%4.2f" $pH)
   	cphstats -i $cpin reordered_cpouts.pH_${pH_fmt} -o pH${pH_fmt}_calcpka.dat --population pH${pH_fmt}_populations.dat

	cphstats -i $cpin reordered_cpouts.pH_${pH_fmt} -n 10000 --cumulative --cumulative-out pH_${pH_fmt}_cumulative.dat
	cphstats -i $cpin reordered_cpouts.pH_${pH_fmt} -n 10000 -r 100000 -R pH_${pH_fmt}_runningavg.dat 

	echo $pH_fmt | awk '{printf("%4.2f ",$1)}'>> titration_curves.dat
	cat pH${pH_fmt}_calcpka.dat | awk '/Frac Prot/ {printf("%5.3f ",1-$10)}' >>titration_curves.dat
	echo $pH_fmt | awk '{printf(" \n",$1)}'>> titration_curves.dat
done

