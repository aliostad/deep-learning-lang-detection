#!/bin/bash

outdir=/lustre/user/houm/projects/AnnoLnc/CLIP/bowtie

function run_bowtie {
	sample=$1
	cmd="bowtie /lustre/user/houm/genome/human/hg19/hg19 -a -p 15 -v 2 -m 1 --best --strata -t -S -q <(zcat ./${sample}_remove_adapter.fastq.gz) > ${outdir}/${sample}.sam"
	echo "Running bowtie for ${sample}..."
	echo $cmd
	bowtie /lustre/user/houm/genome/human/hg19/hg19 -a -p 15 -v 2 -m 1 --best --strata -t -S -q <(zcat ./${sample}_remove_adapter.fastq.gz) > ${outdir}/${sample}.sam
	echo -e "Bowtie done!\n"
	
	cmd="samtools view -S -b -h ${outdir}/${sample}.sam -o ${outdir}/${sample}.bam"
	echo "Converting sam to bam for ${sample}..."
	echo $cmd
	samtools view -S -b -h ${outdir}/${sample}.sam -o ${outdir}/${sample}.bam
	echo -e "Samtools done!\n"

	if [ -e {$outdir}/${sample}.bam ];then
		rm -f ${outdir}/${sample}.sam
	fi
}

while read s
do
	now_date=`date +%y%m%d`
	echo $now_date
	(time run_bowtie $s) 2>&1 | tee ${outdir}/logs/${now_date}-${s}_bowtie_2mm.log
	echo Done!
	echo -e "======================================================\n"
done