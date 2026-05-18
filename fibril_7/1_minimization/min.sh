#!/bin/bash

export AMBERHOME=/data9/stefan/amber24/bin
source /data9/stefan/amber24/amber.sh

pmemd.cuda -O -i min.mdin -p ../0_preparation/insulin_fibril.explicit.parm7 -c ../0_preparation/insulin_fibril.rst7 -o insulin_fibril.min.mdout -r insulin_fibril.min.rst7 -ref ../0_preparation/insulin_fibril.rst7 -cpin ../0_preparation/insulin_fibril.cpin

