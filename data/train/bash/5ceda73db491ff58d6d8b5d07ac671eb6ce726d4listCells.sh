#!/bin/bash

source ./job_settings.sh

echo "Looking up SMRT Cells with ${CHEMISTRY} for ${SAMPLE}..."
grep -l ${SAMPLE} /data/pacbio/primary/*/*/*.metadata.* | xargs grep -l ${CHEMISTRY} > cells_${SAMPLE}_${CHEMISTRY}.dat
echo "Found "$( cat cells_${SAMPLE}_${CHEMISTRY}.dat | wc -l )" SMRT Cells."

rm input_${SAMPLE}_${CHEMISTRY}.fofn
while read line; do
  ls ${line%/*}/Analysis_Results/*.bax.h5 >> input_${SAMPLE}_${CHEMISTRY}.fofn
done < cells_${SAMPLE}_${CHEMISTRY}.dat

echo "Found "$( cat input_${SAMPLE}_${CHEMISTRY}.fofn | wc -l )" .bax.h5 files."
