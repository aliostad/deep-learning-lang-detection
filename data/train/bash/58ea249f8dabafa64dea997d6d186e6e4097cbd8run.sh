#!/bin/bash

echo "input parameters: cluster, process, run path, out path, sample name" $1 $2 $3 $4 $5
CLUSTER=$1
PROCESS=$2
RUNPATH=$3
OUTPATH=$4
SAMPLE=$5

echo ""
echo "CMSSW on Condor"
echo ""

START_TIME=`/bin/date`
echo "started at $START_TIME"

echo ""
echo "parameter set:"
echo "CLUSTER: $CLUSTER"
echo "PROCESS: $PROCESS"
echo "RUNPATH: $RUNPATH"
echo "OUTPATH: $OUTPATH"
echo "SAMPLE: $SAMPLE"

source /cvmfs/cms.cern.ch/cmsset_default.sh
cd $RUNPATH
eval `scram runtime -sh`

cd ${_CONDOR_SCRATCH_DIR}

let "count=${2}+1"

echo "executing ..."
echo "$RUNPATH/$SAMPLE/${SAMPLE}_${count}.py ."
cp $RUNPATH/$SAMPLE/${SAMPLE}_${count}.py .

echo "cmsRun ${SAMPLE}_${count}.py"
cmsRun ${SAMPLE}_${count}.py

echo "mv *.root $OUTPATH/$SAMPLE"
mv *.root $OUTPATH/$SAMPLE

echo "rm ${SAMPLE}_${count}.py"
rm ${SAMPLE}_${count}.py
ls
exitcode=$?
echo "Done execution ..."
END_TIME=`/bin/date`
echo "finished at ${END_TIME}"
exit $exitcode
echo "DONE!"

