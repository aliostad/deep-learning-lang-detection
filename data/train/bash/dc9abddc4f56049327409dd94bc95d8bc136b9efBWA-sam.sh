#!/bin/bash

data_dir=/media/dan/34D5D1CE642D7E36/2013076_Hanfling_Bernd/clone_filtered_demultiplexed_reads/batch1
#reference=/media/dan/34D5D1CE642D7E36/2013076_Hanfling_Bernd/Stacks/Stacks_with_ref/analysis_V1/reference/PRJEB7241_all.fasta
prefix=BWA-8M
index=/media/dan/34D5D1CE642D7E36/2013076_Hanfling_Bernd/Common_carp_genome/Xu_et_al_2014_Nature_version/PRJEB7241_all.fasta
MM=8
threads=7

## Do some work:

##builing indexfile
#cp -v $reference $index.fasta.gz
#gunzip -v $index.fasta.gz

#bwa index -p $index -a is $reference
#rm -v $index.fasta
mkdir bam
	
date

for sample in $(cat sample_list_test.txt)
do 
        echo "\nprocessing sample $sample\n";
        #cp -v $data_dir/$sample* $sample.fq.gz
        #gunzip -v $sample.fq.gz
	bwa aln -n $MM -t $threads $index $data_dir/$sample.fq_1 > $sample.sai
	bwa samse -n $MM $index $sample.sai $data_dir/$sample.fq_1 > $sample-$prefix.sam
	~/Dropbox/PhD/Dan\'s\ PhD\ \(Shared\)/My_Dropbox_Scripts/split_sam.pl  -i $sample-$prefix.sam -o $sample-$prefix >> split_summary.log
	rm -v $sample-$prefix.sam
	cd bam/
	samtools view -@ $threads -bS -o $sample-$prefix-uniq.bam ../$sample-$prefix-uniq.sam
	samtools sort -@ $threads $sample-$prefix-uniq.bam $sample-$prefix-uniq.sorted
	samtools index $sample-$prefix-uniq.sorted.bam
	samtools idxstats $sample-$prefix-uniq.sorted.bam
	rm -v $sample-$prefix-uniq.bam
	cd ../
	gzip -v *.sam
	date
done
