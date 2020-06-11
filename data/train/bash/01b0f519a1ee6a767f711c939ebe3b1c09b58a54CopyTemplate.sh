oCMSSW=$1
oSCMSSW=$2

dCMSSW=$3
dSCMSSW=$4

type="MC"
cp -vfr PatTemplate_CMSSW_"$oCMSSW"_SampleVer_"$oSCMSSW"_SampleType_"$type"_cfg.py PatTemplate_CMSSW_"$dCMSSW"_SampleVer_"$dSCMSSW"_SampleType_"$type"_cfg.py
cp -vfr TopTreeProducerTemplate_CMSSW_"$oCMSSW"_SampleVer_"$oSCMSSW"_SampleType_"$type"_cfg.py TopTreeProducerTemplate_CMSSW_"$dCMSSW"_SampleVer_"$dSCMSSW"_SampleType_"$type"_cfg.py

type="MCGenEvent"
cp -vfr PatTemplate_CMSSW_"$oCMSSW"_SampleVer_"$oSCMSSW"_SampleType_"$type"_cfg.py PatTemplate_CMSSW_"$dCMSSW"_SampleVer_"$dSCMSSW"_SampleType_"$type"_cfg.py
cp -vfr TopTreeProducerTemplate_CMSSW_"$oCMSSW"_SampleVer_"$oSCMSSW"_SampleType_"$type"_cfg.py TopTreeProducerTemplate_CMSSW_"$dCMSSW"_SampleVer_"$dSCMSSW"_SampleType_"$type"_cfg.py

type="data"
cp -vfr PatTemplate_CMSSW_"$oCMSSW"_SampleVer_"$oSCMSSW"_SampleType_"$type"_cfg.py PatTemplate_CMSSW_"$dCMSSW"_SampleVer_"$dSCMSSW"_SampleType_"$type"_cfg.py
cp -vfr TopTreeProducerTemplate_CMSSW_"$oCMSSW"_SampleVer_"$oSCMSSW"_SampleType_"$type"_cfg.py TopTreeProducerTemplate_CMSSW_"$dCMSSW"_SampleVer_"$dSCMSSW"_SampleType_"$type"_cfg.py
