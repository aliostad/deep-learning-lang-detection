#!/bin/bash

BWA_INDEX=${RESOURCES}/${REFERENCE}/bwa/0.7.5/${REFERENCE_NAME}

function _align {
	cpus=$((${CPUS}/2))
	[[ ${cpus} -eq 0 ]] && cpus=1
	for i in $(seq 2); do
		bwa aln -t ${cpus} -R 10000 -q 15 ${BWA_INDEX} ${temp}/${sample}.r${i}.${FASTQ_EXT} > ${temp}/${sample}.r${i}.${FASTQ_EXT}.sai &
	done
	wait

	bwa sampe -a 500 -o 1000000 \
		-r "@RG\tID:${sample}\tSM:${sample}\tLB:${sample}\tPL:ILLUMINA\tCN:OMICRON" \
		${BWA_INDEX} \
		${temp}/${sample}.r{1,2}.${FASTQ_EXT}.sai \
		${temp}/${sample}.r{1,2}.${FASTQ_EXT} | \
		samtools view -Sb - -o ${temp}/${sample}.aligned.bam
}

function _align_single_end {
	echo 'Single-end alignment not supported!'
	exit 1
}
