#!/bin/bash

NTHREADS=1 # Default number of threads, in case we forget to updateNThreads
function updateNThreads {
	# Get the number of cores to use. = num processeors - 1-min load average - 1.
	NTHREADS=$(($(nproc) - $(uptime |grep -oP ": \d+\." |sed -e "s/^\: //" |sed -e "s/\.$//") - 1))
	echo "Can use $NTHREADS threads"
}

#nthreds for number fo core to use
updateNThreads

#open working directory
cd /home/pete/workspace/Project_SN700819R_0100_PCrisp_RSB_Arabidopsis_mRNA

# cuffdiff
# running with -T (all pairwise comparisons)
cuffdiff \
	-p $NTHREADS \
	-o 03-difexp/cuff/cuffdiffv2/ \
	-L Contol,HL30,HL60,HL120,HL60-R7.5,HL60-R15,HL60-R30,HL60-R60,HL60-R60-HL60,HL60-R24h,HL60-R24h-HL60 \
	-b /home/pete/workspace/refseqs/TAIR10_gen/TAIR10_allchr.fa \
	-u \
	-M /home/pete/workspace/refseqs/TAIR10_gen/TAIR10_GFF3_rRNA.gff \
	--library-type fr-unstranded \
	/home/pete/workspace/refseqs/TAIR10_gen/TAIR10_GFF3_genes_transposons.gff \
	mapping/Sample_BJP_317_1_1/tophat_out/accepted_hits.bam,mapping/Sample_BJP_317_1_2/tophat_out/accepted_hits.bam,mapping/Sample_BJP_317_1_3/tophat_out/accepted_hits.bam \
	mapping/Sample_BJP_317_2_1/tophat_out/accepted_hits.bam,mapping/Sample_BJP_317_2_2/tophat_out/accepted_hits.bam,mapping/Sample_BJP_317_2_3/tophat_out/accepted_hits.bam \
	mapping/Sample_BJP_317_3_1/tophat_out/accepted_hits.bam,mapping/Sample_BJP_317_3_2/tophat_out/accepted_hits.bam,mapping/Sample_BJP_317_3_3/tophat_out/accepted_hits.bam \
	mapping/Sample_BJP_317_4_1/tophat_out/accepted_hits.bam,mapping/Sample_BJP_317_4_2/tophat_out/accepted_hits.bam,mapping/Sample_BJP_317_4_3/tophat_out/accepted_hits.bam \
	mapping/Sample_BJP_317_5_1/tophat_out/accepted_hits.bam,mapping/Sample_BJP_317_5_2/tophat_out/accepted_hits.bam,mapping/Sample_BJP_317_5_3/tophat_out/accepted_hits.bam \
	mapping/Sample_BJP_317_6_1/tophat_out/accepted_hits.bam,mapping/Sample_BJP_317_6_2/tophat_out/accepted_hits.bam,mapping/Sample_BJP_317_6_3/tophat_out/accepted_hits.bam \
	mapping/Sample_BJP_317_7_1/tophat_out/accepted_hits.bam,mapping/Sample_BJP_317_7_2/tophat_out/accepted_hits.bam,mapping/Sample_BJP_317_7_3/tophat_out/accepted_hits.bam \
	mapping/Sample_BJP_317_8_1/tophat_out/accepted_hits.bam,mapping/Sample_BJP_317_8_2/tophat_out/accepted_hits.bam,mapping/Sample_BJP_317_8_3/tophat_out/accepted_hits.bam \
	mapping/Sample_BJP_317_9_1/tophat_out/accepted_hits.bam,mapping/Sample_BJP_317_9_2/tophat_out/accepted_hits.bam,mapping/Sample_BJP_317_9_3/tophat_out/accepted_hits.bam \
	mapping/Sample_BJP_317_10_1/tophat_out/accepted_hits.bam,mapping/Sample_BJP_317_10_2/tophat_out/accepted_hits.bam,mapping/Sample_BJP_317_10_3/tophat_out/accepted_hits.bam \
	mapping/Sample_BJP_317_11_1/tophat_out/accepted_hits.bam,mapping/Sample_BJP_317_11_2/tophat_out/accepted_hits.bam,mapping/Sample_BJP_317_11_3/tophat_out/accepted_hits.bam
