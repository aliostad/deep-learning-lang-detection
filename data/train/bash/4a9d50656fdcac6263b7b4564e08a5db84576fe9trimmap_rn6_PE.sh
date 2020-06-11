#!/bin/bash

tubule=$1
sample=${tubule%_1.fastq.gz}
echo "Trimming $sample..."
	
#Trimmomatic

java -jar /home/jae/bin/trimmomatic-0.33.jar PE -threads 8 -phred33 "$sample"_1.fastq.gz "$sample"_2.fastq.gz "$sample"_p1.fastq "$sample"_up1.fastq "$sample"_p2.fastq "$sample"_up2.fastq TRAILING:30 MINLEN:35

rm "$sample"_up*.fastq

#STAR 2.4.2 command
STAR --genomeDir /media/jae/RNAseq_data/reference_genomes/ensembl_rn6/STAR_2.4.2_RNO_rnor6.0 --readFilesIn "$sample"_p1.fastq "$sample"_p2.fastq --runThreadN 8 --limitIObufferSize 50000000 --outFilterType BySJout --outFilterMultimapNmax 20 --alignSJoverhangMin 8 --alignIntronMin 20 --alignIntronMax 1000000 --alignMatesGapMax 1000000 --outFilterMismatchNmax 3 --outSAMstrandField intronMotif --outFilterIntronMotifs RemoveNoncanonical --outSAMtype BAM Unsorted --outFileNamePrefix "$sample". --quantMode TranscriptomeSAM GeneCounts 

mv Log.final.out "$sample"_rn6.log
mv SJ.out.tab "$sample"_rn6.SJ.tab
rm "$sample"_p1.fastq
rm "$sample"_p2.fastq

	





