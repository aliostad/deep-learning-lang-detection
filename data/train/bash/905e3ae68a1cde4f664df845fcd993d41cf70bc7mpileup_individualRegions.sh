

#####
# for each region
#     for each sample
#         if that sample has a sorted.bam for the current region
#             add that sorted.bam to a bam list (should be 1039 samples long)
#         else
#             create an empty mock bam
#             then add it to the list
#
##### this will be in mpileup_individualRegions.sh

REGION_LIST=$1
SAMPLE_LIST=$2
DATA_PATH=$3

for region in $(cat $REGION_LIST)
do
    for sample in $(cat $SAMPLE_LIST)
    do

	if [ -f $DATA_PATH/$sample"_"files/$region"_"files/$sample"_"$region.bam.sorted.bam ]
	then
	    echo " $sample"_"$region.bam.sorted.bam"
	else
	    echo " $sample $region sorted bam not found. Creating empty one..."

	    echo "echo "@SQSN:$region" > $DATA_PATH/$sample"_"files/$region"_"files/$sample"_"$region.sam"
	    echo "@SQSN:$region" > $DATA_PATH/$sample"_"files/$region"_"files/$sample"_"$region.sam

	    echo "echo "@PGID:bwaPN:bwaVN:0.7.12-r1039CL:bwa mem /Volumes/scratch_ssd/csmith/BarnSwallowScratch/AlignmentsAndSnps/Reference/masked_high_coveragesoap_assembly1_k47_min1000bp_scafs.fasta" >> $DATA_PATH/$sample"_"files/$region"_"files/$sample"_"$region.sam   "
	    echo "@PGID:bwaPN:bwaVN:0.7.12-r1039CL:bwa mem /Volumes/scratch_ssd/csmith/BarnSwallowScratch/AlignmentsAndSnps/Reference/masked_high_coveragesoap_assembly1_k47_min1000bp_scafs.fasta" >> $DATA_PATH/$sample"_"files/$region"_"files/$sample"_"$region.sam

	    echo "samtools view -b -o $sample"_"$region.bam -S $sample"_"$region.sam 2> $sample"_"$region.sam_view.stderr"
	    samtools view -b -o $sample"_"$region.bam -S $sample"_"$region.sam 2> $sample"_"$region.sam_view.stderr

	    echo "samtools sort $sample"_"$region.bam $sample"_"$region.bam.sorted 2> $sample"_"$region.sam_sort.stderr"
	    samtools sort $sample"_"$region.bam $sample"_"$region.bam.sorted 2> $sample"_"$region.sam_sort.stderr

	    echo "samtools index $sample"_"$region.bam.sorted.bam 2> $sample"_"$region.sam_index.stderr"
	    samtools index $sample"_"$region.bam.sorted.bam 2> $sample"_"$region.sam_index.stderr

	    echo "samtools mpileup -P ILLUMINA -u -g -t DP -I -f ../bwa/masked_high_coveragesoap_assembly1_k47_min1000bp_scafs.fasta 189../bwa/bam_bai/aln*sorted.bam | bcftools call -c -v -p 0.01 -o out1.vcf"

	fi



    done
done
