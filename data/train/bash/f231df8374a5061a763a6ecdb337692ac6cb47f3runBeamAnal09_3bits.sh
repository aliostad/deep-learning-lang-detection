#!/bin/bash

if (( ${#LOCALRT} < 4 ))
then
    echo Please set up your runtime environment!
    exit
fi

       echo '   '
       echo '   '
echo "      Please choose"
       echo '   '
       echo '   '

echo "  1 - Run 122314 - Nov. 23, 2009"
echo "  2 - Run 123567 - Dec.  4, 2009"
echo "  3 - Run 123575 - Dec.  5, 2009"
echo "  4 - Run 123596 - Dec.  6, 2009"
       echo '   '

read VAR1

case $VAR1 in
    "1") export RUN=122314xpres
#	export RUN=122314preskim
#	export RUN=122314myhltskim
	export RUNDESCR="'Run 122314 Min-Bias Trigger, 142 events'"
	export GLOBALTOFFSET=0.0
#       export BAD_EVENT_LIST=
	export BXNUMS=51
	export GLOBAL_FLAG_MASK=0xC0003
	export TIMEWINDOWMIN=-11
	export TIMEWINDOWMAX=11
	export MINHITGEV=2.
	export MAXGEV2PLOT=100
	export MAXEVENTNUM=30000000
       ;;
    "2")  export RUN=123567xpres
	export RUNDESCR="'Run 123567 BSC,HFTTP Triggers, 2x2'"
	export GLOBALTOFFSET=0.0
#       export BAD_EVENT_LIST=
#       export BXNUMS=51
	export BXNUMS=942
	export GLOBAL_FLAG_MASK=0xC0003
	export TIMEWINDOWMIN=-11
	export TIMEWINDOWMAX=11
	export MINHITGEV=2.
	export MAXGEV2PLOT=100
	export MAXEVENTNUM=1000000
	;;
    "3")export RUNDESCR="'Run 123575 BSC,HFTTP Triggers, 1x1'"
	export RUN=123575xpres
	export GLOBALTOFFSET=0.0
#       export BAD_EVENT_LIST=
	export BXNUMS=51
	export GLOBAL_FLAG_MASK=0xC0003
	export TIMEWINDOWMIN=-11
	export TIMEWINDOWMAX=11
	export MINHITGEV=1.
	export MAXGEV2PLOT=100
	export MAXEVENTNUM=8000000
	;;
    "4")export RUNDESCR="'Run 123596 BSC Triggers, 4x4'"
	export RUN=123575xpres
	export GLOBALTOFFSET=0.0
#       export BAD_EVENT_LIST=
	export BXNUMS=
	export GLOBAL_FLAG_MASK=0xC0003
	export TIMEWINDOWMIN=-11
	export TIMEWINDOWMAX=11
	export MINHITGEV=1.
	export MAXGEV2PLOT=100
	export MAXEVENTNUM=8000000
	;;
esac

echo "Processing $RUN..."
export INCLUDEFILE=run${RUN}Files_cfi

EVENTS=$MAXEVENTNUM

CFGFILE=$0_$1_cfg.py
cat > ${CFGFILE} << EOF

import FWCore.ParameterSet.Config as cms

process = cms.Process("BEAMTIMEANAL")

#----------------------------
# Event Source
#-----------------------------
process.maxEvents = cms.untracked.PSet (
   input = cms.untracked.int32( ${EVENTS} )
)

process.load("MyEDmodules.HcalDelayTuner.${INCLUDEFILE}")

#process.source = cms.Source( "PoolSource",
#   fileNames = cms.untracked.vstring($FILES)
#)

#-----------------------------
# Hcal Conditions: from Global Conditions Tag 
#-----------------------------
# 31X:
#process.load("CalibCalorimetry.HcalPlugins.Hcal_Conditions_forGlobalTag_cff")
#

process.load("FWCore.MessageLogger.MessageLogger_cfi")
process.MessageLogger.cerr.default.limit = cms.untracked.int32(100);
process.MessageLogger.cerr.FwkReport.limit = cms.untracked.int32(100);

#-----------------------------
# Hcal Digis and RecHits
#-----------------------------

process.TFileService = cms.Service("TFileService", 
    fileName = cms.string("bta3bits_run$RUN.root"),
    closeFileFast = cms.untracked.bool(False)
)

# If you want Digis...
process.load("EventFilter.HcalRawToDigi.HcalRawToDigi_cfi")
process.load('Configuration/StandardSequences/FrontierConditions_GlobalTag_cff')
process.GlobalTag.globaltag = 'FIRSTCOLL::All'

process.load("MyEDmodules.HcalDelayTuner.L1skimdef_Bit40_cfi")
process.load("MyEDmodules.HcalDelayTuner.L1skimdef_Bit42_cfi")
process.load("MyEDmodules.HcalDelayTuner.L1skimdef_Bit43_cfi")

process.load("MyEDmodules.HcalDelayTuner.beamtiminganal_cfi")
#
process.hetimeanal.runDescription       = cms.untracked.string(${RUNDESCR})
process.hetimeanal.globalRecHitFlagMask = cms.int32(${GLOBAL_FLAG_MASK})
process.hetimeanal.badEventList         = cms.vint32(${BAD_EVENT_LIST})
process.hetimeanal.acceptedBxNums       = cms.vint32(${BXNUMS})
process.hetimeanal.maxEventNum2plot     = cms.int32(${MAXEVENTNUM})
process.hetimeanal.globalTimeOffset     = cms.double(${GLOBALTOFFSET})
process.hetimeanal.minHitGeV            = cms.double(${MINHITGEV})
process.hetimeanal.recHitEscaleMaxGeV   = cms.double(${MAXGEV2PLOT}.5)
process.hetimeanal.eventDataPset.hbheDigiLabel=cms.untracked.InputTag("hcalDigis")

process.hftimeanal.runDescription       = cms.untracked.string(${RUNDESCR})
process.hftimeanal.globalRecHitFlagMask = cms.int32(${GLOBAL_FLAG_MASK})
process.hftimeanal.badEventList         = cms.vint32(${BAD_EVENT_LIST})
process.hftimeanal.acceptedBxNums       = cms.vint32(${BXNUMS})
#process.hftimeanal.detIds2mask          = cms.vint32(-6,20,4,-6,10,4)
process.hftimeanal.maxEventNum2plot     = cms.int32(${MAXEVENTNUM})
process.hftimeanal.globalTimeOffset     = cms.double(${GLOBALTOFFSET})
process.hftimeanal.minHitGeV            = cms.double(${MINHITGEV})
process.hftimeanal.recHitEscaleMaxGeV   = cms.double(${MAXGEV2PLOT}.5)
process.hftimeanal.eventDataPset.hfDigiLabel=cms.untracked.InputTag("hcalDigis")

process.bta_hebit40 = process.hetimeanal.clone()
process.bta_hebit42 = process.hetimeanal.clone()
process.bta_hebit43 = process.hetimeanal.clone()

process.bta_hfbit40 = process.hftimeanal.clone()
process.bta_hfbit42 = process.hftimeanal.clone()
process.bta_hfbit43 = process.hftimeanal.clone()

process.bit40 = cms.Sequence(process.hltL1seedbit40*process.bta_hebit40*process.bta_hfbit40)
process.bit42 = cms.Sequence(process.hltL1seedbit42*process.bta_hebit42*process.bta_hfbit42)
process.bit43 = cms.Sequence(process.hltL1seedbit43*process.bta_hebit43*process.bta_hfbit43)

process.p = cms.Path(process.hcalDigis*process.bit40+process.bit43+process.bit42)

EOF

cmsRun ${CFGFILE} 2>&1 | tee ./logs/beamTimingAnalyzer_run$RUN.log

echo " -----------------------------------------------------------------  " 
echo "   All done with run ${RUNNUMBER}! Deleting temp .cfg" 
echo " -----------------------------------------------------------------  " 
echo "                                                                    "

#rm ${CFGFILE}
