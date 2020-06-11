#!/bin/bash
echo raw:
type=raw
for sample in DGay* 
do
  if grep --quiet hpv16 $sample/virus-findings/fusions_${type}.txt 
  then
    echo -e ${sample}'\t'hpv16
  fi
  if grep --quiet hpv33 $sample/virus-findings/fusions_${type}.txt
  then
    echo -e ${sample}'\t'hpv33
  fi
  if grep --quiet hpv35 $sample/virus-findings/fusions_${type}.txt
  then
    echo -e ${sample}'\t'hpv35
  fi
  if grep --quiet hhv $sample/virus-findings/fusions_${type}.txt
  then
    echo -e ${sample}'\t'hhv
  fi
done
echo candidates: 
type=candidates
for sample in DGay* 
do
  if grep --quiet hpv16 $sample/virus-findings/fusions_${type}.txt 
  then
    echo -e ${sample}'\t'hpv16
  fi
  if grep --quiet hpv33 $sample/virus-findings/fusions_${type}.txt
  then
    echo -e ${sample}'\t'hpv33
  fi
  if grep --quiet hpv35 $sample/virus-findings/fusions_${type}.txt
  then
    echo -e ${sample}'\t'hpv35
  fi
  if grep --quiet hhv $sample/virus-findings/fusions_${type}.txt
  then
    echo -e ${sample}'\t'hhv
  fi
done
