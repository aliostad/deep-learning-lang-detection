
SAMPLE_LIST=$1  # line separated list of sample names (must correspond to fasta names somehow)
DATA_PATH=$2  # path to the directory containing the sample fqs
REFERENCE=$3

echo
echo "   !!! WARNING: check the current settings of this script !!!"
echo
echo "using sample list:  $SAMPLE_LIST ..."
echo "using path to fastq's: $DATA_PATH ..."
echo "using reference: $REFERENCE ..."
echo

 #just once
#done   bwa index ref.fa
#done   samtools faidx ref.fa 

for sample in $(cat $SAMPLE_LIST | awk '{print $1}')
do
     #making sample directories
    echo $sample
    echo "mkdir $sample"_"files"
    mkdir $sample"_"files

     #change into sample dir
    echo "cd $sample"_"files"
    cd $sample"_"files

     #link .fq's into the sample dir's
    echo "ln -s  $DATA_PATH/$sample.fq ./$sample.fq"
#    ln -s $DATA_PATH/$sample.fastq ./$sample.fq
    ln -s $DATA_PATH/$sample.fq ./$sample.fq

    # trimmomatic (trim steps carried out in the order specified on the command line, so do adapters first)
    echo "java -jar /Volumes/scratch_ssd/csmith/Software/Trimmomatic/trimmomatic-0.33.jar SE -phred33 $sample.fq $sample"_"trimmed.fq ILLUMINACLIP:/Volumes/scratch_ssd/csmith/BarnSwallowScratch/Reference/Contaminants/contaminants.fa:2:30:4 LEADING:30 TRAILING:30 AVGQUAL:30 MINLEN:50 2> $sample.trim.log"
    # heavy screen and trim
    java -jar /Volumes/scratch_ssd/csmith/Software/Trimmomatic/trimmomatic-0.33.jar SE -phred33 $sample.fq $sample"_"trimmed.fq ILLUMINACLIP:/Volumes/scratch_ssd/csmith/BarnSwallowScratch/Reference/Contaminants/contaminants.fa:2:30:4 LEADING:30 TRAILING:30 AVGQUAL:30 MINLEN:50 2> $sample.trim.log

    # screen for contaminants
    echo "bwa mem /Volumes/scratch_ssd/csmith/BarnSwallowScratch/Reference/Contaminants/combined_UnivecPhixHuman.fa $sample"_"trimmed.fq 1> $sample"_"screen.sam 2> $sample"_"screen.bwa.stderr"
    bwa mem /Volumes/scratch_ssd/csmith/BarnSwallowScratch/Reference/Contaminants/combined_UnivecPhixHuman.fa $sample"_"trimmed.fq 1> $sample"_"screen.sam 2> $sample"_"screen.bwa.stderr

    echo "grep -v '^@' $sample"_"screen.sam | awk '$2 == 4' | awk '{print "@"$1"\n"$10"\n+\n"$11}' > $sample"_"screened.fq"
    grep -v '^@' $sample"_"screen.sam | awk '$2 == 4' | awk '{print "@"$1"\n"$10"\n+\n"$11}' > $sample"_"screened.fq

    # align to reference
    echo "bwa mem $REFERENCE $sample"_"screened.fq 1> $sample.sam 2> $sample.bwa.stderr" 
    bwa mem $REFERENCE $sample"_"screened.fq 1> $sample.sam 2> $sample.bwa.stderr
    echo "bwa mem $REFERENCE $sample"_"trimmed.fq 1> $sample.sam 2> $sample.bwa.stderr"
    bwa mem $REFERENCE $sample"_"trimmed.fq 1> $sample.sam 2> $sample.bwa.stderr

    echo "samtools view -b -o $sample.bam -S $sample.sam 2> $sample.sam_view.stderr"
    samtools view -b -o $sample.bam -S $sample.sam 2> $sample.sam_view.stderr

    echo "samtools sort $sample.bam $sample.sorted 2> $sample.sam_sort.stderr"
    samtools sort $sample.bam $sample.sorted 2> $sample.sam_sort.stderr

    echo "samtools index $sample.sorted.bam 2> $sample.sam_index.stderr"
    samtools index $sample.sorted.bam 2> $sample.sam_index.stderr

#    ulimit -n 10000
#    ulimit -a
#    samtools mpileup -P ILLUMINA -u -g -t DP -f reference sorted.bams | bcftools call -c -v -f GQ -o out1.vcf

     #delete things you don't need: unsorted sams, bams, etc
    echo "rm $sample.fq"
    rm $sample.fq
    echo "rm $sample"_"trimmed.fq"
    rm $sample"_"trimmed.fq
    echo "rm $sample"_"screened.fq"
    rm $sample"_"screened.fq
    echo "rm $sample"_"screen.sam"
    rm $sample"_"screen.sam
    echo "rm $sample.sam"
    rm $sample.sam
    echo "rm $sample.bam"
    rm $sample.bam

     #switch out of sample dir
    echo "cd ../"
    cd ..
    echo

done

