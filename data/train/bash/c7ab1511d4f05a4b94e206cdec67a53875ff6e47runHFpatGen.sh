#!/bin/bash

if (( ${#LOCALRT} < 4 ))
then
    echo Please set up your runtime environment!
    exit
fi

if (( $# < 1 ))
then
    echo Usage: $0 global_shift_integer_ns
    exit
fi

export GLOBALSHIFTNS=$1

CFGFILE=${0%.sh}_$1_cfg.py
TABLENAME=hfdelpatgen_$1.csv

cat > ${CFGFILE} << EOF

import FWCore.ParameterSet.Config as cms

process = cms.Process("HFDELPATGEN")

#----------------------------
# Event Source
#-----------------------------

process.maxEvents = cms.untracked.PSet(input=cms.untracked.int32(0))
process.source    = cms.Source("EmptySource")

process.load("FWCore.MessageLogger.MessageLogger_cfi")
process.MessageLogger.cerr.INFO.limit = cms.untracked.int32(-1);

#-----------------------------
# Hcal Digis and RecHits
#-----------------------------

process.load("MyEDmodules.HcalDelayTuner.hfdelaypatterngen_cfi")
process.hfdelaypatgen.globalShiftNS=cms.untracked.int32(${GLOBALSHIFTNS})
process.hfdelaypatgen.tableFilename=cms.untracked.string("${TABLENAME}")
process.p = cms.Path(process.hfdelaypatgen)

EOF

cmsRun ${CFGFILE} 2>&1

#rm ${CFGFILE}
