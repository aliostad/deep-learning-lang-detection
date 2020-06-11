#!/bin/bash
#Step 1 of RNA-seq analysis: File organization and trimming

#The fastq files are stored in separate directories. This will go through each directory and concatenate files from the same sample and lane into one file and output to prcessed_data directory.
#This loop will preserve lane separations in the same sample.
for sample in Sample_* ; do
    echo "[`date`]: Combining files for $sample...";
    mkdir /home/yasser/bio720/final_project/data/processed_data/$sample;
    LANES=($(ls $sample/ | grep gz | perl -pe 's|^.*?_.*?_||' | perl -pe 's|_.*||' | sort | uniq)); 
    for lane in "${LANES[@]}"; do

	cat $sample/*"$lane"_R1* > /home/yasser/bio720/final_project/data/processed_data/$sample/"$sample"_"$lane"_R1.fastq.gz;
        cat $sample/*"$lane"_R2* > /home/yasser/bio720/final_project/data/processed_data/$sample/"$sample"_"$lane"_R2.fastq.gz;

    done;

done;

cd /home/yasser/bio720/final_project/data/processed_data/;



#Trim reads in a paired fashion while maintining separation of lanes. Notable trimming parameters are trim quality threshold trimq is 20, and minlength is 60. Keep both reads unless both don't pass trimming filter. Remove concatenated non-trimmed files after to save space.

#Quality threshold of 20 is pretty stringent, and in the future I would probably decrease it, but it was too time consuming to re-run again.

for sample in Sample_*; do
##FastQC analysis prior to trimming
    echo "[`date`]: FastQC analysis: pre-process for $sample...";
    /usr/local/fastqc/fastqc -o /home/yasser/bio720/final_project/data/fastqc_reports/pre_process "$sample"/*;
####
##Adapter trimming and quality filtering and removal of original datasets (which are still stored elsewhere)
    echo "[`date`]: Trimming and adapter removal for $sample...";
    LANES_again=($(ls $sample/ | grep gz | perl -pe 's|^.*?_.*?_||' | perl -pe 's|_.*||' | sort | uniq)); 
    for lane_again in "${LANES_again[@]}"; do

	/home/yasser/localprograms/bbmap/bbduk.sh in=$sample/"$sample"_"$lane_again"_R1.fastq.gz in2=$sample/"$sample"_"$lane_again"_R2.fastq.gz ref=/home/yasser/resources/truseq.fa out=$sample/"$sample"_"$lane_again"_R1.bbduk.fastq.gz out2=$sample/"$sample"_"$lane_again"_R2.bbduk.fastq.gz ziplevel=9 threads=12 removeifeitherbad=f ktrim=r qtrim=t trimq=20 minlength=60 tbo tpe 2> $sample/bbduk_stats_"$lane_again".txt;
	rm -f $sample/"$sample"_"$lane_again"_R1.fastq.gz $sample/"$sample"_"$lane_again"_R2.fastq.gz
    done;
####
##FastQC analysis post trimming
    echo "[`date`]: FastqC analysis: post-process for $sample...";
    /usr/local/fastqc/fastqc -o /home/yasser/bio720/final_project/data/fastqc_reports/post_process $sample/*;
####
done;



