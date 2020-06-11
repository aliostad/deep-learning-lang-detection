#!/bin/bash
EOSdir=~/eos/atlas/atlasgroupdisk/phys-higgs/HSG1/MxAOD/h008
#MxAODlist=~/MxAOD_h008/packages/HGamTools/data/input/mc.txt 
#MxAODlist=~/MxAOD_h008/packages/HGamTools/data/input/data.txt 
MxAODlist=/afs/cern.ch/user/a/athompso/temp/HGamTools/data/input/mc.txt
#EOSdir=$1
#MxAODlist=$2

[ ! -d "$EOSdir" ] && echo MUST MOUNT EOS First: eosmount ~/eos  && exit 1

while read p; do
  sample=$(echo $p | awk '{print $1}')
#  [ "$sample" =~ \# ] && continue
  [[ $sample = \#* ]] && continue
  [ -z $sample ] && continue
  
  
  #echo $sample
  if [ ! -f $EOSdir/mc_25ns/${sample}.* ] && [ ! -f $EOSdir/mc_50ns/${sample}.* ]; then
    echo $sample Not Found!
    echo $sample >> MissingDatasets.txt
  fi

done <$MxAODlist
