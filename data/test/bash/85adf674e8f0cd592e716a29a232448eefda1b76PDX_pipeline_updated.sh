#!/bin/bash
#$ -cwd
#$ -e logs
#$ -o logs
#$ -l mem=64G

############################
#Process RNA-Seq PDX samples, paired-end.
#Map to combined index, remove mouse reads, map to human index.
#Run quantification and QC on alignment to human.
#New York Genome Center
#Heather Geiger (hmgeiger@nygenome.org)
#Version 04-13-2015
############################

#Declare NB of CPU.
#Note: If want to run the alignments multi-threaded, should also adjust the SGE arguments accordingly.

NB_CPU=1

#Accept as arguments the sample name (with Sample_) and whether or not the samples are stranded. Run from the project directory.

if [ $# -lt 2 ]
then
echo "Usage: $0 sample (with Sample_) strandedness(yes/no)"
echo "Run from project directory"
exit 1
fi

sample=$1
stranded=$2

#Set variable for combined human/mouse index.

STAR_Index=/data/NYGC/Resources/Indexes/STAR/Ensembl_mouse_and_human_xenograft_overhang_49

#Concatenate FASTQs and output to /scratch.

Raw_dir=`pwd`

if [ ! -e /scratch/${sample}_tmp ];then mkdir /scratch/${sample}_tmp;fi

cat $Raw_dir/${sample}/fastq/*R1.fastq.gz > /scratch/${sample}_tmp/${sample}_R1.fastq.gz
cat $Raw_dir/${sample}/fastq/*R2.fastq.gz > /scratch/${sample}_tmp/${sample}_R2.fastq.gz
FASTQ1=/scratch/${sample}_tmp/${sample}_R1.fastq.gz
FASTQ2=/scratch/${sample}_tmp/${sample}_R2.fastq.gz

#Map combined human/mouse index.

/data/NYGC/Software/STAR/STAR_2.4.0c/STAR \
 --runMode alignReads \
 --genomeLoad NoSharedMemory \
 --genomeDir $STAR_Index \
 --readFilesIn $FASTQ1 $FASTQ2 \
 --readFilesCommand zcat \
 --runThreadN $NB_CPU \
 --outFileNamePrefix ${sample}/STAR_alignment_to_mouse_and_human/${sample}_vs_mouse_and_human_combined_index_ \
  --outSAMunmapped Within \
 --outReadsUnmapped None \
 --outSAMstrandField intronMotif \
 --outSAMattributes All

#Remove reads mapping unambiguously to mouse. Also count the mouse reads (to be output to QC page later), and output separate alignments for reads mapping ambiguously and unambiguously to mouse in case we want to use them later.

/data/NYGC/Software/samtools/samtools-0.1.19/samtools view -bS ${sample}/STAR_alignment_to_mouse_and_human/${sample}_vs_mouse_and_human_combined_index_Aligned.out.sam > ${sample}/STAR_alignment_to_mouse_and_human/${sample}_vs_mouse_and_human_combined_index_Aligned.out.bam

if [ -s ${sample}/STAR_alignment_to_mouse_and_human/${sample}_vs_mouse_and_human_combined_index_Aligned.out.bam ]
then
rm ${sample}/STAR_alignment_to_mouse_and_human/${sample}_vs_mouse_and_human_combined_index_Aligned.out.sam
fi

/data/NYGC/Software/samtools/samtools-0.1.19/samtools view -F 256 ${sample}/STAR_alignment_to_mouse_and_human/${sample}_vs_mouse_and_human_combined_index_Aligned.out.bam > /scratch/${sample}_tmp/${sample}_vs_mouse_and_human_combined_index_minus_secondary_alignments.sam

SAM=/scratch/${sample}_tmp/${sample}_vs_mouse_and_human_combined_index_minus_secondary_alignments.sam

/data/NYGC/Software/samtools/samtools-0.1.19/samtools view -H ${sample}/STAR_alignment_to_mouse_and_human/${sample}_vs_mouse_and_human_combined_index_Aligned.out.bam > ${sample}/STAR_alignment_to_mouse_and_human/${sample}_minus_reads_uniquely_mapped_to_mouse.sam

/data/NYGC/Software/samtools/samtools-0.1.19/samtools view -H ${sample}/STAR_alignment_to_mouse_and_human/${sample}_vs_mouse_and_human_combined_index_Aligned.out.bam > ${sample}/STAR_alignment_to_mouse_and_human/${sample}_reads_uniquely_mapped_to_mouse.sam

/data/NYGC/Software/samtools/samtools-0.1.19/samtools view -H ${sample}/STAR_alignment_to_mouse_and_human/${sample}_vs_mouse_and_human_combined_index_Aligned.out.bam > ${sample}/STAR_alignment_to_mouse_and_human/${sample}_reads_multiply_mapped_to_mouse.sam

awk '$3 ~ /human/' $SAM >> ${sample}/STAR_alignment_to_mouse_and_human/${sample}_minus_reads_uniquely_mapped_to_mouse.sam

#This line can be removed to include only alignments where the primary alignment is to human.

awk '$3 ~ /mouse/ && $12 !~ /^NH:i:1$/' $SAM >> ${sample}/STAR_alignment_to_mouse_and_human/${sample}_minus_reads_uniquely_mapped_to_mouse.sam

#Make separate files for mouse unique and multiply mapped reads.

awk '$3 ~ /mouse/ && $12 !~ /^NH:i:1$/' $SAM >> ${sample}/STAR_alignment_to_mouse_and_human/${sample}_reads_multiply_mapped_to_mouse.sam

awk '$3 ~ /mouse/ && $12 ~ /^NH:i:1$/' $SAM >> ${sample}/STAR_alignment_to_mouse_and_human/${sample}_reads_uniquely_mapped_to_mouse.sam

#Count mouse unique reads and output this to a file. Also, convert all SAM files to BAM and delete the SAM.

echo "Uniquely_mapping_to_mouse" | tr '\n' '\t' > ${sample}/STAR_alignment_to_mouse_and_human/${sample}_reads_mapping_to_human_and_mouse_counts.txt

awk '!seen[$1]++' ${sample}/STAR_alignment_to_mouse_and_human/${sample}_reads_uniquely_mapped_to_mouse.sam | wc -l >> ${sample}/STAR_alignment_to_mouse_and_human/${sample}_reads_mapping_to_human_and_mouse_counts.txt

/data/NYGC/Software/samtools/samtools-0.1.19/samtools view -bS ${sample}/STAR_alignment_to_mouse_and_human/${sample}_minus_reads_uniquely_mapped_to_mouse.sam > ${sample}/STAR_alignment_to_mouse_and_human/${sample}_minus_reads_uniquely_mapped_to_mouse.bam

rm ${sample}/STAR_alignment_to_mouse_and_human/${sample}_minus_reads_uniquely_mapped_to_mouse.sam

/data/NYGC/Software/samtools/samtools-0.1.19/samtools view -bS ${sample}/STAR_alignment_to_mouse_and_human/${sample}_reads_uniquely_mapped_to_mouse.sam > ${sample}/STAR_alignment_to_mouse_and_human/${sample}_reads_uniquely_mapped_to_mouse.bam

rm ${sample}/STAR_alignment_to_mouse_and_human/${sample}_reads_uniquely_mapped_to_mouse.sam

/data/NYGC/Software/samtools/samtools-0.1.19/samtools view -bS ${sample}/STAR_alignment_to_mouse_and_human/${sample}_reads_multiply_mapped_to_mouse.sam > ${sample}/STAR_alignment_to_mouse_and_human/${sample}_reads_multiply_mapped_to_mouse.bam

rm ${sample}/STAR_alignment_to_mouse_and_human/${sample}_reads_multiply_mapped_to_mouse.sam

#Make FASTQs for reads minus mouse uniques.

/data/NYGC/Software/bam2fastq/bam2fastq-1.1.0/bam2fastq -f ${sample}/STAR_alignment_to_mouse_and_human/${sample}_minus_reads_uniquely_mapped_to_mouse.bam -o /scratch/${sample}_tmp/${sample}_minus_mouse_uniques#.fastq

FASTQ1=/scratch/${sample}_tmp/${sample}_minus_mouse_uniques_1.fastq
FASTQ2=/scratch/${sample}_tmp/${sample}_minus_mouse_uniques_2.fastq

#Now map back to human.

STAR_Index=/data/NYGC/Resources/Indexes/STAR/hg19_Gencode18_overhang49

/data/NYGC/Software/STAR/STAR_2.4.0c/STAR \
  --runMode alignReads \
 --genomeLoad LoadAndRemove \
 --genomeDir $STAR_Index \
 --readFilesIn $FASTQ1 $FASTQ2 \
 --runThreadN $NB_CPU \
 --outFileNamePrefix ${sample}/STAR_alignment_to_human_after_remove_mouse/${sample}_vs_human_after_remove_mouse_reads_ \
 --outSAMunmapped Within \
 --outReadsUnmapped None \
 --outSAMstrandField intronMotif \
 --outSAMattributes All \
 --chimSegmentMin 20

#Convert SAM to BAM, then delete SAM.

READ_GROUP="RGID=${sample} RGLB=${sample} RGDS=\"hg19\" RGPL=Illumina  RGPU=1  RGSM=${sample}  RGCN=\"NYGenome\" RGDT=`date --iso-8601`"

java -Djava.io.tmpdir=/scratch -Xmx24g -jar /data/NYGC/Software/picard-tools/picard-tools-1.77/AddOrReplaceReadGroups.jar \
 INPUT=${sample}/STAR_alignment_to_human_after_remove_mouse/${sample}_vs_human_after_remove_mouse_reads_Aligned.out.sam \
 OUTPUT=${sample}/STAR_alignment_to_human_after_remove_mouse/${sample}_vs_human_after_remove_mouse_reads_Aligned.out.WithReadGroup.sorted.bam \
 SORT_ORDER=coordinate $READ_GROUP

BAM=${sample}/STAR_alignment_to_human_after_remove_mouse/${sample}_vs_human_after_remove_mouse_reads_Aligned.out.WithReadGroup.sorted.bam

/data/NYGC/Software/samtools/samtools-0.1.18/samtools index \
 $BAM

if [ -s $BAM ];then rm ${sample}/STAR_alignment_to_human_after_remove_mouse/${sample}_vs_human_after_remove_mouse_reads_Aligned.out.sam;fi

#Run a full set of QC on the alignment to human.

if [ $strand = yes ]
then
featureCounts_strand=2
PICARD_STRAND=SECOND_READ_TRANSCRIPTION_STRAND
else
featureCounts_strand=0
PICARD_STRAND=NONE
fi

featureCounts_annotation=/data/NYGC/Resources/ENCODE/Gencode/gencode.v18.annotation.gtf
PICARD_REF_FLAT=/data/NYGC/Resources/RNASeqPipelineResources/gencode.v18.refFlat.txt
READ_GROUP="RGID=${sample} RGLB=${sample} RGDS=\"hg19\" RGPL=Illumina  RGPU=1  RGSM=${sample}  RGCN=\"NYGenome\" RGDT=`date --iso-8601`"
RSeQC_annotation=/data/NYGC/Resources/ENCODE/Gencode/gencode.v18.annotation.bed

#Run MarkDuplicates to look at duplication rate.

java -Djava.io.tmpdir=/scratch -Xmx24g -jar /data/NYGC/Software/picard-tools/picard-tools-1.83/MarkDuplicates.jar \
 I=$BAM \
 O=/scratch/${sample}_tmp/${sample}_Aligned.out.WithReadGroup.sorted.markdup.bam \
 METRICS_FILE=$Raw_dir/${sample}/Stats/${sample}_MarkDuplicates.metrics.txt  ASSUME_SORTED=TRUE

rm /scratch/${sample}_tmp/${sample}_Aligned.out.WithReadGroup.sorted.markdup.bam

#Run featureCounts to get counts per gene.

/data/NYGC/Software/Subread/subread-1.4.3-p1-Linux-x86_64/bin/featureCounts -s $featureCounts_strand -a $featureCounts_annotation -o $Raw_dir/${sample}/featureCounts/${sample}_counts.txt $BAM

#Run Picard to get read distribution, strandedness info, gene body coverage.

java -Djava.io.tmpdir=/scratch -Xmx24g -jar /data/NYGC/Software/picard-tools/picard-tools-1.77/CollectRnaSeqMetrics.jar \
 INPUT=$BAM \
 OUTPUT=$Raw_dir/${sample}/Stats/${sample}_RNAMetrics.txt \
 REF_FLAT=$PICARD_REF_FLAT \
 STRAND=$PICARD_STRAND \
 CHART=$Raw_dir/${sample}/Stats/${sample}_RNAMetrics.pdf \
 METRIC_ACCUMULATION_LEVEL=ALL_READS

#Run RSeQC to check GC content and inner distance.

export PYTHONPATH=$PYTHONPATH:/nfs/sw/rseqc/rseqc-2.6.1/lib/python2.7/site-packages

/nfs/sw/python/python-2.7.8/bin/python /nfs/sw/rseqc/rseqc-2.6.1/bin/read_GC.py \
 -i $BAM \
 -o ${sample}/Stats/${sample}

/nfs/sw/python/python-2.7.8/bin/python /nfs/sw/rseqc/rseqc-2.6.1/bin/inner_distance.py \
 -k 20000000 \
 -u 500 \
 -i $BAM \
 -r $RSeQC_annotation \
 -o ${sample}/Stats/${sample}

#Remove any accumulated temp files.

rm -r /scratch/${sample}_tmp
