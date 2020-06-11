

SAMPLELIST=$1
SAMPLEPATH=$2
RAREFACTION=$3 # number of reads you want to rarefy to

for sample in $(cat $SAMPLELIST)
do 
    echo
    echo $sample

    # link fq over
    ln -s $SAMPLEPATH/$sample.fq

    # trim first!
    echo "trimming"
    java -jar /Volumes/scratch_ssd/csmith/Software/Trimmomatic/trimmomatic-0.33.jar SE -phred33 $sample.fq $sample"_"trimmed.fq ILLUMINACLIP:/Volumes/scratch_ssd/csmith/BarnSwallowScratch/Reference/Contaminants/contaminants.fa:2:30:10 LEADING:30 TRAILING:30 AVGQUAL:30 MINLEN:50 2> $sample.trim.log

    # get fq size with wc to save a little time
    FQSIZE=$(wc -l $sample"_"trimmed.fq | awk '{print$1}')

    # rarefy
    echo "python /Volumes/scratch_ssd/csmith/Scripts/rarifyFq.py $sample"_"trimmed.fq $RAREFACTION $FQSIZE > $sample"_"rarefied.fq"
    python /Volumes/scratch_ssd/csmith/Scripts/rarifyFq.py $sample"_"trimmed.fq $RAREFACTION $FQSIZE > $sample"_"rarefied.fq

done


