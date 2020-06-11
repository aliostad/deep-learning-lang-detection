#!/bin/sh

ulimit -c 0

cd /gpfs/cms/users/candelis/CMSSW_5_3_14_patch1
eval `scramv1 runtime -sh`
cd -

cp /gpfs/cms/users/candelis/work/ZbSkim/test/demoanalyzer_cfg.py job.py

pileup=$1

shift

cut=$1
echo "process.demoEle.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoEle1b.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoEle2b.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoElePum.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoElePum1b.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoElePum2b.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoElePup.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoElePup1b.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoElePup2b.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoEleUp.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoEleUp1b.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoEleUp2b.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoEleDown.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoEleDown1b.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoEleDown2b.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoMuo.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoMuo1b.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoMuo2b.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoMuoPum.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoMuoPum1b.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoMuoPum2b.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoMuoPup.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoMuoPup1b.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoMuoPup2b.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoMuoUp.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoMuoUp1b.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoMuoUp2b.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoMuoDown.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoMuoDown1b.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoMuoDown2b.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoEleBtag.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoEleBtag1b.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoEleBtag2b.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoMuoBtag.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoMuoBtag1b.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoMuoBtag2b.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoEle2.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoMuo2.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoEleMuo.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoEleMuo1b.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoEleMuo2b.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoEleMuoUp.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoEleMuoUp1b.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoEleMuoUp2b.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoEleMuoDown.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoEleMuoDown1b.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoEleMuoDown2b.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoEleMuoPum.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoEleMuoPum1b.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoEleMuoPum2b.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoEleMuoPup.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoEleMuoPup1b.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoEleMuoPup2b.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoElePur.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoElePur1b.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoElePur2b.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoMuoPur.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoMuoPur1b.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoMuoPur2b.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoEleMuoPur.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoEleMuoPur1b.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoEleMuoPur2b.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoEleJerUp.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoEleJerUp1b.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoEleJerUp2b.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoEleJerDown.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoEleJerDown1b.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoEleJerDown2b.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoMuoJerUp.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoMuoJerUp1b.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoMuoJerUp2b.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoMuoJerDown.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoMuoJerDown1b.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoMuoJerDown2b.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoEleMuoJerUp.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoEleMuoJerUp1b.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoEleMuoJerUp2b.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoEleMuoJerDown.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoEleMuoJerDown1b.icut = cms.untracked.uint32("$cut")" >> job.py
echo "process.demoEleMuoJerDown2b.icut = cms.untracked.uint32("$cut")" >> job.py

shift

echo "fileList = cms.untracked.vstring()" >> job.py
i=1
while [ $i -le $# ]; do
  file=`echo ${!i} | sed -e 's;/gpfs/grid/srm/cms;;'`
  echo "fileList.extend(['"$file"'])" >> job.py
  file=`basename ${!i} | sed -e 's/patTuple/rootTuple/'`
  echo "process.TFileService.fileName = cms.string('"$file"')" >> job.py
  i=$((i+1))
done
echo "process.source.fileNames = fileList" >> job.py

(time cmsRun -j job.xml job.py) > job.log 2>&1

exit
