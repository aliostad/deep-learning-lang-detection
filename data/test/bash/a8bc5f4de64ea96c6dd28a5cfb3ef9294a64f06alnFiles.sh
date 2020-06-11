set -x
pushd ~/SCRATCH/projAML/WXS/step_6_callVariant
for bamfile in ~/YS2559/scratch/AML/29*/*/*/*/*/*/*/*/*rmdup.new.bam ; do 
#echo bamfile = $bamfile ;
PATIENT_ID=$(echo $bamfile | awk -F'/' '{print $13}') ;
PATIENT_ID=${PATIENT_ID##*-} ;
SAMPLE=$(echo $bamfile | awk -F'/' '{print $15}') ;
#echo $SAMPLE ;
SAMPLE=${SAMPLE%-*} ;
#echo $SAMPLE ;
SAMPLE=${SAMPLE##*-} ;
#echo $SAMPLE ;
ln -s $bamfile ${PATIENT_ID}-${SAMPLE}.rmdup.new.bam ; 
ln -s $bamfile.bai ${PATIENT_ID}-${SAMPLE}.rmdup.new.bam.bai ;
done
popd
set +x
