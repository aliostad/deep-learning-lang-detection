#! /bin/bash

NTUPLE_VERSION='v10'
SAMPLES=('WToMuNu' 'QCDMu2030' 'QCDMu3050' 'QCDMu5080' 'QCDMu80120')
#SAMPLES=('WToMuNu' 'QCDMu3050')

for SAMPLE in ${SAMPLES[@]} ; do
    echo $SAMPLE
    ./comparePlots.exe results/rateResults_${NTUPLE_VERSION}_53X_HLT701_13TeV_25PU_25ns_${SAMPLE}.root \
                       results/rateResults_${NTUPLE_VERSION}_62X_HLT701_13TeV_20PU_25ns_${SAMPLE}.root \
	               results/rateResults_${NTUPLE_VERSION}_53X_HLT701_8TeV_25PU_25ns_${SAMPLE}.root
    mv results/comparePlots results/comparePlots_${SAMPLE}
done
