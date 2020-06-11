

SAMPLELIST=$1
SAMPLEPATH=$2
RAREFACTION=$3 # number of reads you want to rarefy to

for sample in $(cat $SAMPLELIST)
do 
    echo
    echo $sample

    # link fq over
    ln -s $SAMPLEPATH/$sample.fq

    # get fq size with wc to save a little time
    FQSIZE=$(wc -l $sample.fq | awk '{print$1}')

    # rarefy
    echo "python /Volumes/scratch_ssd/csmith/Scripts/rarifyFq.py $sample.fq $RAREFACTION $FQSIZE > $sample"_"rarefied.fq"
    python /Volumes/scratch_ssd/csmith/Scripts/rarifyFq.py $sample.fq $RAREFACTION $FQSIZE > $sample"_"rarefied.fq

done


