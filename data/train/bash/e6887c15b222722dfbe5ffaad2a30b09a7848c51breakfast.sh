#!/bin/bash --login

OUTDIR=${SCRATCH}/breakfast_transcriptome
mkdir -pv ${OUTDIR}
ref="/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/WholeGenomeFasta/genome"
annofile="/work/projects/melanomics/tools/breakfast/data/ensembl_genes.bed"
#annofile="/work/projects/melanomics/tools/breakfast/data/hg19_refGene.bed"

detection()
{
    sample=$1
    input="/work/projects/melanomics/analysis/transcriptome/${sample}/tophat_out_trimmed_NCBI_Fusion/${sample}.fusion.bam"
    output=${OUTDIR}/${sample}.bf
    oarsub -l nodes=1,walltime=120 -n ${sample}.bf "./run_detection.sh ${input} ${ref} ${output}"
    # ./run_detection.sh ${input} ${ref} ${output}
}


blacklist()
{
    sample=$1
    input="${OUTDIR}/${sample}.bf.sv"
    output=${OUTDIR}/${sample}.bf.blacklist.txt
    #./run_blacklist.sh ${input} ${output}
    oarsub -l nodes=1,walltime=120 -n ${sample}.bl "./run_blacklist.sh ${input} ${output}"
}


filtering()
{
    sample=$1
    sample_bl=$2
    input=${OUTDIR}/${sample}.bf.sv
    #output=${OUTDIR}/${sample}.bf.filtered.sv
    output=${OUTDIR}/${sample}.bf.filtered_woPat4.sv
    #blacklist=${OUTDIR}/blacklist.txt
    blacklist=${OUTDIR}/blacklist_woPat4.txt
    #./run_filtering.sh ${input} ${output} ${blacklist}
    #oarsub -l nodes=1,walltime=120 -n ${sample}.filter "./run_filtering.sh ${input} ${output} ${blacklist}"
    oarsub -l nodes=1,walltime=120 -n ${sample}.filter_woPat4 "./run_filtering.sh ${input} ${output} ${blacklist}"
}


annotation()
{
    sample=$1
    input=${OUTDIR}/${sample}.bf.filtered_woPat4.sv
    #output=${OUTDIR}/${sample}.bf.filtered.anno.RefSeq.sv
    #output=${OUTDIR}/${sample}.bf.filtered.anno.ENS.sv
    output=${OUTDIR}/${sample}.bf.filtered_woPat4.anno.ENS.sv
    #oarsub -t bigmem -l walltime=120 -n ${sample}.anno.RefSeq "./run_annotation.sh ${input} ${output} ${annofile}"
    oarsub -t bigmem -l walltime=120 -n ${sample}.anno_woPat4.RefSeq "./run_annotation.sh ${input} ${output} ${annofile}"
  }


tabulate()
{
    sample=$1
    #input=${OUTDIR}/${sample}.bf.filtered.anno.RefSeq.sv
    #input=${OUTDIR}/${sample}.bf.filtered.anno.ENS.sv
    input=${OUTDIR}/${sample}.bf.filtered_woPat4.anno.ENS.sv
    #output=${OUTDIR}/${sample}.bf.filtered.anno.cand.RefSeq.sv
    #output=${OUTDIR}/${sample}.bf.filtered.anno.cand.ENS.sv
    output=${OUTDIR}/${sample}.bf.filtered_woPat4.anno.cand.ENS.sv
    #oarsub -t bigmem -l walltime=120 -n ${sample}.cand "./run_tabulate.sh ${input} ${output}"
    oarsub -t bigmem -l walltime=120 -n ${sample}.woPat4.cand "./run_tabulate.sh ${input} ${output}"
}



#for k in NHEM patient_4_NS patient_4_PM patient_2 patient_6 pool
#    do 
#      detection $k
#    done


#for k in NHEM pool patient_4_NS
#     do
# 	blacklist ${k}
#     done


#for i in NHEM pool patient_4_NS ; do cat ${i}.bf.blacklist.txt >> blacklist.txt ; done

#for k in patient_2 patient_4_PM patient_6
#     do
#       filtering ${k}
#    done


# for k in patient_2 patient_4_PM patient_6
#     do
#	annotation $k
#     done


 for k in patient_2 patient_4_PM patient_6
     do
 	tabulate $k
     done
