#!/bin/bash                                                                                                

SAMPLE=$1;
VERSION=MC_36X_V2
eval `scramv1 runtime -sh`;

cd ${SAMPLE};

crab_dir=`\ls -rt1 | grep "crab_" | grep -v "exodiphotonbkganalyzer" | tail -1 | awk '{print $NF}'`;
echo $crab_dir;
cd ${crab_dir}/res;

nroot=`\ls -1 diphoton_tree_*root | grep -c diphoton_tree`;
nlog=`\ls -1 CMSSW_*stdout | grep -c CMSSW`;
nerror=`grep -i Error CMSSW_*stdout | grep -ic error`;

echo $nroot $nlog $nerror;

rm -f diphotonTree_${SAMPLE}.root diphotonTree_${SAMPLE}.log diphotonTree_${SAMPLE}.log.gz;

hadd -f diphotonTree_${SAMPLE}.root diphoton_tree_*root;
cat CMSSW*stdout > diphotonTree_${SAMPLE}.log;
gzip -f diphotonTree_${SAMPLE}.log;

rfmkdir /castor/cern.ch/user/t/torimoto/physics/diphoton/ntuples/mc/${VERSION}/${SAMPLE};
rfcp diphotonTree_${SAMPLE}.log.gz /castor/cern.ch/user/t/torimoto/physics/diphoton/ntuples/mc/${VERSION}/${SAMPLE};
rfcp diphotonTree_${SAMPLE}.root  /castor/cern.ch/user/t/torimoto/physics/diphoton/ntuples/mc/${VERSION}/${SAMPLE};


#cd -;

