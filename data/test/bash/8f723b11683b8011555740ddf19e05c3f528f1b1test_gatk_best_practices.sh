#!/bin/bash --login

MYTMP=$SCRATCH/test_gatk/
mkdir $MYTMP
ref=/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/WholeGenomeFasta/genome.fa
dbsnp=/work/projects/melanomics/data/broad2/bundle/dbsnp_138.b37.vcf

index()
{
    oarsub -lcore=2,walltime=12 "./run_index.sh $ref"
}    

bwa_pe_se()
{

    sample=$1
    sample_dir=$2
    sample_name=$3
    for k in 5 6 7 8
    do
	lane=$k
	read1=`ls /work/projects/melanomics/analysis/transcriptome/$sample_dir/adapter_quality_filter_trim/*$k.ft.R1_1.fastq.noadapter.quality_trimmed_1`
	read2=`ls /work/projects/melanomics/analysis/transcriptome/$sample_dir/adapter_quality_filter_trim/*$k.ft.R1_1.fastq.noadapter.quality_trimmed_2`
	readse=`ls /work/projects/melanomics/analysis/transcriptome/$sample_dir/adapter_quality_filter_trim/*$k.ft.R1_1.fastq.noadapter.quality_trimmed_SE`

	read_group="\"@RG\tID:$lane\tSM:$sample_name\tPL:Illumina\tLB:NA\tPU:NA\""
	output_pe=$MYTMP/$sample_name.lane$lane.pe.sam
	output_se=$MYTMP/$sample_name.lane$lane.se.sam
	cores_pe=4
	cores_se=4
	
	#./run_bwa.sh $read_group $ref $read1 $read2 $output_pe $cores_pe
	#./run_bwa_se.sh $read_group $ref $readse $output_se $cores_se

	oarsub -tbigsmp -lcore=$cores_pe,walltime=120 -n ${output_pe##*/} "./run_bwa.sh $read_group $ref $read1 $read2 $output_pe $cores_pe"
	oarsub -tbigsmp -lcore=$cores_se,walltime=120 -n ${output_se##*/} "./run_bwa_se.sh $read_group $ref $readse $output_se $cores_se"
    done
}


merge_pe_se()
{
    sample=$1
    for k in 5 6 7 8
    do
	lane=$k
        input_pe=$MYTMP/$sample.lane$lane.pe.sam
        input_se=$MYTMP/$sample.lane$lane.se.sam
        output=$MYTMP/$sample.lane$lane.bam
	oarsub -lcore=2,walltime=24 -n $sample.$lane "./merge_pe_se.sh $input_pe $input_se $output"
    done
}	

merge()
{
    sample=$1
    cmd=" ./run_merge_lanes.sh $MYTMP/$sample.lane5.bam $MYTMP/$sample.lane6.bam $MYTMP/$sample.lane7.bam $MYTMP/$sample.lane8.bam $MYTMP/$sample.bam;"
    #Reheader to allow multiple read groups in the header
    cmd="${cmd} ./run_reheader.sh $MYTMP/$sample.lane5.bam $MYTMP/$sample.lane6.bam $MYTMP/$sample.lane7.bam $MYTMP/$sample.lane8.bam $MYTMP/$sample.bam $MYTMP/$sample.reheader.bam"
    oarsub -lcore=2,walltime=24 -n $sample "$cmd"
    #"./run_merge_lanes.sh $MYTMP/$sample.lane5.bam $MYTMP/$sample.lane6.bam $MYTMP/$sample.lane7.bam $MYTMP/$sample.lane8.bam $MYTMP/$sample.bam"
    echo "oarsub -lcore=2,walltime=24 -n $sample $cmd"
    
}


sort_and_mark_duplicates()
{
    sample=$1
    input=$MYTMP/$sample.bam
    output=$MYTMP/$sample.sorted.markdup.bam
    oarsub -lcore=2,walltime=24 -n $sample "./run_sort_markduplicates.sh $input $output"

}

realign()
{
    sample=$1
    input=$MYTMP/$sample.sorted.markdup.bam
    output=$MYTMP/$sample.sorted.markdup.realn.bam
    intervals=$MYTMP/$sample.sorted.markdup.realn.intervals
    oarsub -lcore=2,walltime=24 -n $sample "./run_realignment.sh $input $ref $output $intervals"
}


recalibrate()
{
    sample=$1
    input=$MYTMP/$sample.sorted.markdup.realn.bam
    output=$MYTMP/$sample.sorted.markdup.realn.recal.bam
    grp=${output%.bam}.grp
    oarsub -lcore=2,walltime=24 -n $sample "./run_recalibrate.sh $input $ref $dbsnp $output $grp"
    
}

unifiedgenotyper()
{
    sample=$1
    input=$MYTMP/$sample.sorted.markdup.realn.recal.bam
    output=$MYTMP/$sample.sorted.markdup.realn.recal.ugt.vcf
    cores=8
    oarsub -lcore=$cores,walltime=24 -n $sample "./run_ugt.sh $input $output $dbsnp $ref $cores"
}

variant_recalibrate()
{
    sample=$1
    input=$MYTMP/$sample.sorted.markdup.realn.recal.ugt.vcf
    output=$MYTMP/$sample.sorted.markdup.realn.recal.ugt.recal.vcf
    ./run_variant_recalibrate.sh $input $output
}


## Pipeline
#index


#bwa_pe_se patient_2 patient_2 patient_2
#bwa_pe_se patient_6 patient_6 patient_6 
#for k in patient_6 NHEM pool
#do
#    bwa_pe_se $k $k $k
#done
#bwa_pe_se patient_4 patient_4/NS patient_4_NS
#bwa_pe_se patient_4 patient_4/PM patient_4_PM



#for k in patient_2 #patient_4_NS patient_4_PM patient_6 # NHEM pool patient_6
#do
#    merge_pe_se $k
#done



#for k in patient_2 #pool NHEM #patient_2 patient_4_NS patient_4_PM
#do
#    merge $k
#done


#for k in patient_2 #pool NHEM
#do
#    sort_and_mark_duplicates $k
#done

#for k in patient_2
#do
#    realign $k
#done

#for k in patient_2
#do
#    recalibrate $k
#done


for k in patient_2
do
    unifiedgenotyper $k
done


