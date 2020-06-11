#!/bin/bash
#$ -M david.wragg@toulouse.inra.fr
#$ -m a

# Modify environment for Java7
module load bioinfo/Java7 

# set -e will cause script to terminate on an error, set +e allows it to continue
set -e

# ==============================================================================
# MAP.sh
# ==============================================================================
echo -e "\n\e[1m\e[34m======================\e[0m"
echo -e "\e[93m\e[1mSeqApiPop \e[0m\e[93mNGS pipeline\e[0m"
echo -e "\e[1m\e[34m======================\e[0m"
usage()
{
  echo -e "\n\e[96mUsage\e[0m"
  echo -e "\e[92m   $0 -i <parameters file> -s <sample> [options]\e[0m"
  echo -e "\n\e[96mDetails\e[0m"
  echo -e "\e[92mThis pipeline has been developed to map Illumina HiSeq reads generated for the SeqApiPop project. All of the parameters in the parameter file require setting. This module requires the installation of BWA, GATK, and Picard.\e[0m"
  echo -e "\n\e[96mOPTIONS:\e[0m"
  echo -e "\e[92m\t-i <str>\tPath to input file containing pipeline parameters\e[0m"
  echo -e "\e[92m\t-f <str>\tPath to folder containing fastq.gz files to be mapped\e[0m"
  echo -e "\e[92m\t-s <str>\tSample read file name prefix\e[0m"
  echo -e "\e[92m\t-b <int>\tNumber of bootstrap iterations during BQSR [3]\e[0m"
  echo -e "\n"

}

# Clear variables and set defaults for nThreads, BQSR bootstraps and RAM
INFILE=
PAIRED="T"
QFIX="F"
BOOTS=2
REF=
IN=
OUT=
SAMPLE=
BWA=
PICARD=
GATK=
PLATYPUS=
VCFT=
PERLSCRIPTS=
RSCRIPTS=
BAYSIC=

while getopts ":e:s:f:p:" opt; do
  case $opt in
    e) EMBOSS=${OPTARG};;
    f) IN=${OPTARG};;
    s) SAMPLE=${OPTARG};;
    p) PAIRED=${OPTARG};;
  esac
done

if [[ -z ${EMBOSS} ]] | [[ -z ${SAMPLE} ]] | [[ -z ${IN} ]]
then
  usage
  exit 1
fi


# ==============================================================================
# Convert phred scores from 64 to 33
# ==============================================================================

gunzip ${IN}/${SAMPLE}/${SAMPLE}*1.fastq.gz
gunzip ${IN}/${SAMPLE}/${SAMPLE}*2.fastq.gz


if [ "${PAIRED}" = "T" ]; then
#  echo -e "\e[91m[1/${STEPS}] BWA:Map reads [BWA MEM] \n\t\e[94m\e[1m<- \e[0m\e[92m${REF} \n\t\e[94m\e[1m<- \e[0m\e[92m${IN}/${READS_1} \n\t\e[94m\e[1m<- \e[0m\e[92m${IN}/${READS_2} \n\t\e[94m\e[1m-> \e[0m\e[96m${OUT}/${SAMPLE}/${SAMPLE}.sam \e[0m"
  mv ${IN}/${SAMPLE}/${SAMPLE}_*1.fastq ${IN}/${SAMPLE}/${SAMPLE}_p64_R1.fastq
  mv ${IN}/${SAMPLE}/${SAMPLE}_*2.fastq ${IN}/${SAMPLE}/${SAMPLE}_p64_R2.fastq
  ${EMBOSS}/seqret fastq-illumina::${IN}/${SAMPLE}/${SAMPLE}_p64_R1.fastq fastq::${IN}/${SAMPLE}/${SAMPLE}_R1.fastq
  ${EMBOSS}/seqret fastq-illumina::${IN}/${SAMPLE}/${SAMPLE}_p64_R2.fastq fastq::${IN}/${SAMPLE}/${SAMPLE}_R2.fastq
  bgzip ${IN}/${SAMPLE}/${SAMPLE}_R1.fastq
  bgzip ${IN}/${SAMPLE}/${SAMPLE}_R2.fastq
fi
if [ "${PAIRED}" = "F" ]; then
#  echo -e "\e[91m[1/${STEPS}] BWA:Map reads [BWA MEM] \n\t\e[94m\e[1m<- \e[0m\e[92m${REF} \n\t\e[94m\e[1m<- \e[0m\e[92m${IN}/${READS_1} \e[0m\e[96m${OUT}/${SAMPLE}/${SAMPLE}.sam \e[0m"
  mv ${IN}/${SAMPLE}.fastq ${IN}/${SAMPLE}_p64.fastq
  ${EMBOSS}/seqret fastq-illumina::${IN}/${SAMPLE}_p64.fastq fastq::${IN}/${SAMPLE}.fastq
  bgzip ${IN}/${SAMPLE}.fastq
fi

bgzip ${IN}/${SAMPLE}/${SAMPLE}_p64_R1.fastq
bgzip ${IN}/${SAMPLE}/${SAMPLE}_p64_R2.fastq

