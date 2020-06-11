#!/bin/bash
#$ -M david.wragg@toulouse.inra.fr
#$ -m a

# Modify environment for Java7
module load bioinfo/Java7 

# set -e will cause script to terminate on an error, set +e allows it to continue
set -e

# ==============================================================================
# cushaw.sh
# ==============================================================================


# Clear variables and set defaults for nThreads, BQSR bootstraps and RAM
FILES=
OUT=
SAMPLE=
CREF=/home/dwragg/save/Apis/CUSHAW3-Apis
REF=/home/dwragg/save/Apis/Apis_mellifera.fa
BOOTS=2
PICARD=
GATK=
PLATYPUS=
VCFT=
PERLSCRIPTS=
RSCRIPTS=
BAYSIC=
INFILE=

while getopts ":i:f:o:s:b:" opt; do
  case $opt in
    i) INFILE=${OPTARG};;
    f) FILES=${OPTARG};;
    o) OUT=${OPTARG};;
    s) SAMPLE=${OPTARG};;
    b) BOOTS=${OPTARG};;
  esac
done

if [[ -z ${FILES} ]] | [[ -z ${OUT} ]] | [[ -z ${SAMPLE} ]] | [[ -z ${INFILE} ]]
then
  usage
  exit 1
fi



# ==============================================================================
# Read in variables
# ==============================================================================

while IFS="=" read name value
do

  if [[ "$name" == "PICARD" ]]; then PICARD=${value//\"/}; fi
  if [[ "$name" == "GATK" ]]; then GATK=${value//\"/}; fi
  if [[ "$name" == "PLATYPUS" ]]; then PLATYPUS=${value//\"/}; fi
  if [[ "$name" == "VCFT" ]]; then VCFT=${value//\"/}; fi
  if [[ "$name" == "BAYSIC" ]]; then BAYSIC=${value//\"/}; fi
  if [[ "$name" == "PERLSCRIPTS" ]]; then PERLSCRIPTS=${value//\"/}; fi
  if [[ "$name" == "RSCRIPTS" ]]; then RSCRIPTS=${value//\"/}; fi

done < ${INFILE}



IN=($(cut -f1 ${FILES}))
printf "%s\n" "${IN[@]}"


# Prep directory
mkdir -p ${OUT}/${SAMPLE}/vcfs
mkdir -p ${OUT}/${SAMPLE}/metrics

STEPS=7

# Map SOLID reads
cushaw3 calign -r ${CREF} \
  -f ${IN[@]} \
  -o ${OUT}/${SAMPLE}/${SAMPLE}.sam \
  -rgid Wallberg \
  -rgsm ${SAMPLE} \
  -rglb ${SAMPLE} \
  -rgpl solid \
  -rgpu Uppsala




# Sort SAM into coordinate order and save as BAM
echo -e "\e[91m[2/${STEPS}] Picard:SortSam [coordinate] \n\t\e[94m\e[1m<- \e[0m\e[92m${OUT}/${SAMPLE}/${SAMPLE}.sam \n\t\e[94m\e[1m-> \e[0m\e[96m${OUT}/${SAMPLE}/${SAMPLE}.bam\e[0m"
logfile=${OUT}/${SAMPLE}/logs/${SAMPLE}_PicardSortSam.log
java -d64 -jar $PICARD/SortSam.jar \
  INPUT=${OUT}/${SAMPLE}/${SAMPLE}.sam \
  OUTPUT=${OUT}/${SAMPLE}/${SAMPLE}.bam \
  SORT_ORDER=coordinate \
  QUIET=T \
  VERBOSITY=ERROR \
  VALIDATION_STRINGENCY=LENIENT \
  2> >(tee "$logfile")
rm ${OUT}/${SAMPLE}/${SAMPLE}.sam

# Mark duplicates 
echo -e "\e[91m[3/${STEPS}] Picard:MarkDuplicates \n\t\e[94m\e[1m<- \e[0m\e[92m${OUT}/${SAMPLE}/${SAMPLE}.bam \n\t\e[94m\e[1m-> \e[0m\e[96m${OUT}/${SAMPLE}/${SAMPLE}_dup.bam\e[0m"
logfile=${OUT}/${SAMPLE}/logs/${SAMPLE}_PicardMarkDuplicates.log
java -d64 -jar ${PICARD}/MarkDuplicates.jar \
  INPUT=${OUT}/${SAMPLE}/${SAMPLE}.bam \
  OUTPUT=${OUT}/${SAMPLE}/${SAMPLE}_dup.bam \
  METRICS_FILE=${OUT}/${SAMPLE}/metrics/${SAMPLE}_dup.metrics \
  MAX_FILE_HANDLES_FOR_READ_ENDS_MAP=1000 \
  QUIET=T \
  VERBOSITY=ERROR \
  VALIDATION_STRINGENCY=LENIENT \
  2> >(tee "$logfile")
rm ${OUT}/${SAMPLE}/${SAMPLE}.bam


# Index BAM file 
echo -e "\e[91m[4/${STEPS}]:BuildBamIndex\e[0m"
logfile=${OUT}/${SAMPLE}/logs/${SAMPLE}_PicardBuildBamIndex.log
java -d64 -jar ${PICARD}/BuildBamIndex.jar \
  INPUT=${OUT}/${SAMPLE}/${SAMPLE}_dup.bam \
  QUIET=T \
  VERBOSITY=ERROR \
  2> >(tee "$logfile")


# ==============================================================================
# Local realignment around INDELs
# ==============================================================================

# Create target interval list
echo -e "\e[91m[5/${STEPS}] GATK:RealignerTargetCreator \n\t\e[94m\e[1m<- \e[0m\e[92m${OUT}/${SAMPLE}/${SAMPLE}_dup.bam \n\t\e[94m\e[1m-> \e[0m\e[96m${OUT}/${SAMPLE}/logs/${SAMPLE}_dup_intervals.list\e[0m"
logfile=${OUT}/${SAMPLE}/logs/${SAMPLE}_RealignerTargetCreator.err
java -d64 -jar ${GATK}/GenomeAnalysisTK.jar \
  -T RealignerTargetCreator \
  -R ${REF} \
  -I ${OUT}/${SAMPLE}/${SAMPLE}_dup.bam \
  -o ${OUT}/${SAMPLE}/logs/${SAMPLE}_dup_intervals.list \
  -l FATAL \
  2> >(tee "$logfile")

# Perform realignment around INDELs 
echo -e "\e[91m[6/${STEPS}] GATK:IndelRealigner \n\t\e[94m\e[1m<- \e[0m\e[92m${OUT}/${SAMPLE}/${SAMPLE}_dup.bam \n\t\e[94m\e[1m-> \e[0m\e[96m${OUT}/${SAMPLE}/${SAMPLE}_realn.bam\e[0m"
logfile=${OUT}/${SAMPLE}/logs/${SAMPLE}_IndelRealigner.err
java -d64 -jar ${GATK}/GenomeAnalysisTK.jar \
  -T IndelRealigner \
  -R ${REF} \
  -I ${OUT}/${SAMPLE}/${SAMPLE}_dup.bam \
  -targetIntervals ${OUT}/${SAMPLE}/logs/${SAMPLE}_dup_intervals.list \
  -o ${OUT}/${SAMPLE}/${SAMPLE}_realn.bam \
  -l FATAL \
  2> >(tee "$logfile")


# Delete surplus files
rm ${OUT}/${SAMPLE}/${SAMPLE}_dup.bam
rm ${OUT}/${SAMPLE}/${SAMPLE}_dup.bai


# ==============================================================================
# Cannot perform BQSR on Solid reads mapped with cushaw
# ==============================================================================

echo -e "\e[91m[7/${STEPS}] GATK:Base Quality Score Recalibration (BQSR) \n\t\e[94m\e[1m|- \e[0m\e[92mNumber of iterations: ${BOOTS} \n\t\e[94m\e[1m<- \e[0m\e[92m${OUT}/${SAMPLE}/${SAMPLE}_realn.bam \n\t\e[94m\e[1m-> \e[0m\e[96m${OUT}/${SAMPLE}/${SAMPLE}_bootstrap.bam\e[0m"

# Call SNPs > BQSR > Call SNPs > BQSR > Call SNPs > BQSR > Call SNPs
cp ${OUT}/${SAMPLE}/${SAMPLE}_realn.bam ${OUT}/${SAMPLE}/${SAMPLE}_bootstrap.bam
samtools index ${OUT}/${SAMPLE}/${SAMPLE}_bootstrap.bam

rm ${OUT}/${SAMPLE}/${SAMPLE}_realn.b*

