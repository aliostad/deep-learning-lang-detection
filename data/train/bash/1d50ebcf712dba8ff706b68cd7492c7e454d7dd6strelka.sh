#!/bin/bash --login

OUTDIR="/work/projects/melanomics/analysis/genome/strelka"
mkdir -pv ${OUTDIR}

strelka()
{
    sample=$1
    normal="/work/projects/melanomics/analysis/genome/${sample}_NS/bam/${sample}_NS.bam"
    tumor="/work/projects/melanomics/analysis/genome/${sample}_PM/bam/${sample}_PM.bam"
    output="${OUTDIR}/${sample}"
    oarsub -l nodes=1,walltime=120 -n ${sample}_strelka  "./run_strelka.sh ${normal} ${tumor} ${output}"
}

for i in patient_4 patient_5 patient_6 patient_7 patient_8 #patient_2
    do 
      strelka ${i}
    done
