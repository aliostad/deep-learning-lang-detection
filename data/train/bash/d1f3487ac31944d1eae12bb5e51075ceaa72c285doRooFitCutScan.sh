#!/bin/bash

resfile=rooFitCutsScan_cutdata.out

invokeRoot()
{
    run=$1
    cut=$2
    n=$3
    lo=$4
    hi=$5
    tmpfile=tmp.C
    path=/scratch/frmeier/
    file=$path$run.root
    echo ".L rooFitCutScan01.C+" > $tmpfile
    echo "rooFitCutScan01(\"$file\",\"\",\"$cut\",$n,$lo,$hi); > rooFitCutScan_${cut//\//}_${run}.out" >> $tmpfile
    echo ".q" >> $tmpfile
    root -l < tmp.C
    rm tmp.C
    mv rooFitCutScan0.pdf rooFitCutScan_${cut//\//}_${run}.pdf
    mv tmp.root rooFitCutScan_${cut//\//}_${run}_16.root
    awk '/this Cut/ { print $3,$4,$6,$8,$9 }' rooFitCutScan_${cut//\//}_${run}.out >> $resfile
}

# -------------------------------

echo > $resfile

for run in run129p16 # run127
do
    invokeRoot $run "mjp" 10 0.02 0.32
    invokeRoot $run "ptjp" 9 1 10 
    invokeRoot $run "ml0" 9 0.001 0.01
    invokeRoot $run "Kshypo" 10 0 0.05
    invokeRoot $run "ptl0" 10 1 5
    invokeRoot $run "rptpr" 9 0.5 5
    invokeRoot $run "rptpi" 9 0.2 2
    invokeRoot $run "alphal0" 9 0.001 0.01
    invokeRoot $run "d3l0" 9 1 19
    invokeRoot $run "d3l0/d3El0" 9 1 28 
    invokeRoot $run "problb" 9 0.005 0.05
    invokeRoot $run "alphalb" 9 0.02 0.2
done

exit 0

# echo ${file//\//} strips away any /

