#!/bin/bash
#$ -M david.wragg@toulouse.inra.fr
#$ -m a

# Modify environment for Java7
module load bioinfo/Java7 

# set -e will cause script to terminate on an error, set +e allows it to continue
set -e

# ==============================================================================
# stat.sh
# ==============================================================================
echo -e "\n\e[1m\e[34m====================================\e[0m"
echo -e "\e[93m\e[1mSeqApiPop\e[0m\e[93m: Mapping statistics\e[0m"
echo -e "\e[1m\e[34m====================================\e[0m"
usage()
{
  echo -e "\n\e[96mUsage\e[0m"
  echo -e "\e[92m   $0 -s <sample name> -f <path to fastq reads> -o <output path> [options]\e[0m"
  echo -e "\n\e[96mDetails\e[0m"
  echo -e "\e[92mThis pipeline has been developed to map Illumina HiSeq reads generated for the SeqApiPop project. All of the parameters in the parameter file require setting. This module requires the installation of GATK, Picard, SAMtools, BEDtools, VCFtools and R.\e[0m"
  echo -e "\n\e[96mOPTIONS:\e[0m"
  echo -e "\e[92m\t-i <str>\tPath to input file containing pipeline parameters [defafult = /save/seqapipop/Scripts/params]\e[0m"
  echo -e "\n\e[96mRequires\e[0m"
  echo -e "\e[92mGATK\e[0m"
  echo -e "\e[92mPicard\e[0m"
  echo -e "\e[92mSAMtools\e[0m"
  echo -e "\e[92mBEDtools\e[0m"
  echo -e "\e[92mCoverage-Poisson.R\e[0m"
  echo -e "\e[92mPlot-GATKcov.R\e[0m"
  echo -e "\e[92mPlot-GATKcovStats.R\e[0m"
  echo -e "\e[92mPlot-Flagstat.R\e[0m"
  echo -e "\n"

}

# Clear variables and set defaults for nThreads, BQSR bootstraps and RAM
INFILE=/save/seqapipop/Scripts/params
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
BEAGLE=

while getopts ":i:f:s:o:" opt; do
  case $opt in
    i) INFILE=${OPTARG};;
    f) IN=${OPTARG};;
    s) SAMPLE=${OPTARG};;
    o) OUT=${OPTARG};;
  esac
done

if [[ -z ${INFILE} ]] | [[ -z ${SAMPLE} ]] | [[ -z ${OUT} ]]
then
  usage
  exit 1
fi

# ==============================================================================
# Read in variables
# ==============================================================================

while IFS="=" read name value
do

  if [[ "$name" == "REF" ]]; then REF=${value//\"/}; fi
  if [[ "$name" == "IN" ]]; then IN=${value//\"/}; fi
  if [[ "$name" == "SAMPLE" ]]; then SAMPLE=${value//\"/}; fi
  if [[ "$name" == "BWA" ]]; then BWA=${value//\"/}; fi
  if [[ "$name" == "PICARD" ]]; then PICARD=${value//\"/}; fi
  if [[ "$name" == "GATK" ]]; then GATK=${value//\"/}; fi
  if [[ "$name" == "PLATYPUS" ]]; then PLATYPUS=${value//\"/}; fi
  if [[ "$name" == "VCFT" ]]; then VCFT=${value//\"/}; fi
  if [[ "$name" == "BAYSIC" ]]; then BAYSIC=${value//\"/}; fi
  if [[ "$name" == "PERLSCRIPTS" ]]; then PERLSCRIPTS=${value//\"/}; fi
  if [[ "$name" == "RSCRIPTS" ]]; then RSCRIPTS=${value//\"/}; fi
  if [[ "$name" == "BEAGLE" ]]; then BEAGLE=${value//\"/}; fi

done < ${INFILE}

if [[ "$REF" == "" ]]; then echo "REF missing"; exit 0; fi
if [[ "$IN" == "" ]]; then echo "IN path missing"; exit 0; fi
if [[ "$OUT" == "" ]]; then echo "OUT path missing"; exit 0; fi
if [[ "$SAMPLE" == "" ]]; then echo "SAMPLE missing"; exit 0; fi
if [[ "$BWA" == "" ]]; then echo "BWA missing"; exit 0; fi
if [[ "$PICARD" == "" ]]; then echo "PICARD path missing"; exit 0; fi
if [[ "$GATK" == "" ]]; then echo "GATK path missing"; exit 0; fi
if [[ "$PLATYPUS" == "" ]]; then echo "PLATYPUS path missing"; exit 0; fi
if [[ "$VCFT" == "" ]]; then echo "VCFT path missing"; exit 0; fi
if [[ "$BAYSIC" == "" ]]; then echo "BAYSIC path missing"; exit 0; fi
if [[ "$PERLSCRIPTS" == "" ]]; then echo "PERLSCRIPTS path missing"; exit 0; fi
if [[ "$RSCRIPTS" == "" ]]; then echo "RSCRIPTS path missing"; exit 0; fi

# Create folders for storing files
mkdir -p ${OUT}/${SAMPLE}/logs
mkdir -p ${OUT}/${SAMPLE}/metrics
mkdir -p ${OUT}/${SAMPLE}/vcfs


# Number of steps in pipeline, this will need updating if additional steps are added, to provide an idea of how long is remaining whilst running the pipe
STEPS=8



# ==============================================================================
# Calculate mapping metrics on realn BAM
# ==============================================================================

# Depth of coverage via GATK
echo -e "\e[91m[1/${STEPS}] GATK:DepthOfCoverage \n\t\e[94m\e[1m<- \e[0m\e[92m${OUT}/${SAMPLE}/${SAMPLE}_bootstrap.bam \n\t\e[94m\e[1m-> \e[0m\e[96m${OUT}/${SAMPLE}/metrics/${SAMPLE}_GATKcov\e[0m"
logfile=${OUT}/${SAMPLE}/logs/${SAMPLE}_DpethOfCoverage.err
java -d64 -jar ${GATK}/GenomeAnalysisTK.jar \
  -T DepthOfCoverage \
  -R ${REF} \
  -I ${OUT}/${SAMPLE}/${SAMPLE}_bootstrap.bam \
  -o ${OUT}/${SAMPLE}/metrics/${SAMPLE}_GATKcov \
  -ct 2 -ct 5 -ct 8 \
  --omitDepthOutputAtEachBase \
  --omitIntervalStatistics \
  --omitLocusTable \
  -l FATAL \
  2> >(tee "$logfile")
${RSCRIPTS}/Plot-GATKcov.R ${SAMPLE} ${OUT}/${SAMPLE}/metrics/${SAMPLE}_GATKcov.sample_summary
${RSCRIPTS}/Plot-GATKcovStats.R ${SAMPLE} ${OUT}/${SAMPLE}/metrics/${SAMPLE}_GATKcov.sample_statistics

# Flagstat
echo -e "\e[91m[2/${STEPS}] SAMtools:flagstat \n\t\e[94m\e[1m<- \e[0m\e[92m${OUT}/${SAMPLE}/${SAMPLE}_bootstrap.bam \n\t\e[94m\e[1m-> \e[0m\e[96m${OUT}/${SAMPLE}/metrics/${SAMPLE}.flagstat\e[0m"
logfile=${OUT}/${SAMPLE}/logs/${SAMPLE}_flagstat.err
samtools flagstat ${OUT}/${SAMPLE}/${SAMPLE}_bootstrap.bam \
  > ${OUT}/${SAMPLE}/metrics/${SAMPLE}.flagstat \
  2> >(tee "$logfile")
${RSCRIPTS}/Plot-Flagstat.R ${SAMPLE} ${OUT}/${SAMPLE}/metrics/${SAMPLE}.flagstat

# Alignment Summary Metrics
echo -e "\e[91m[3/${STEPS}] Picard:CollectAlignmentSummaryMetrics \n\t\e[94m\e[1m<- \e[0m\e[92m${OUT}/${SAMPLE}/${SAMPLE}_bootstrap.bam \n\t\e[94m\e[1m-> \e[0m\e[96m${OUT}/${SAMPLE}/metrics/${SAMPLE}_aln.metrics\e[0m"
logfile=${OUT}/${SAMPLE}/logs/${SAMPLE}_PicardAlignmentMetrics.log
java -d64 -jar $PICARD/CollectAlignmentSummaryMetrics.jar \
  INPUT=${OUT}/${SAMPLE}/${SAMPLE}_bootstrap.bam \
  OUTPUT=${OUT}/${SAMPLE}/metrics/${SAMPLE}_aln.metrics \
  REFERENCE_SEQUENCE=${REF} \
  QUIET=T \
  VERBOSITY=ERROR \
  VALIDATION_STRINGENCY=LENIENT \
  2> >(tee "$logfile")

# Insert Size Metrics
echo -e "\e[91m[4/${STEPS}] Picard:CollectInsertSizeMetrics \n\t\e[94m\e[1m<- \e[0m\e[92m${OUT}/${SAMPLE}/${SAMPLE}_bootstrap.bam \n\t\e[94m\e[1m-> \e[0m\e[96m${OUT}/${SAMPLE}/metrics/${SAMPLE}_ins.metrics \n\t\e[94m\e[1m-> \e[0m\e[96m${OUT}/${SAMPLE}/metrics/${SAMPLE}_ins_hist.pdf\e[0m"
logfile=${OUT}/${SAMPLE}/logs/${SAMPLE}_PicardInsertSizeMetrics.log
java -d64 -jar $PICARD/CollectInsertSizeMetrics.jar \
  INPUT=${OUT}/${SAMPLE}/${SAMPLE}_bootstrap.bam \
  HISTOGRAM_FILE=${OUT}/${SAMPLE}/metrics/${SAMPLE}_ins_hist.pdf \
  METRIC_ACCUMULATION_LEVEL=ALL_READS \
  OUTPUT=${OUT}/${SAMPLE}/metrics/${SAMPLE}_ins.metrics \
  REFERENCE_SEQUENCE=${REF} \
  QUIET=T \
  VERBOSITY=ERROR \
  VALIDATION_STRINGENCY=LENIENT \
  2> >(tee "$logfile")

# Quality Score Distribution
echo -e "\e[91m[5/${STEPS}] Picard:QualityScoreDistribution \n\t\e[94m\e[1m<- \e[0m\e[92m${OUT}/${SAMPLE}/${SAMPLE}_bootstrap.bam \n\t\e[94m\e[1m-> \e[0m\e[96m${OUT}/${SAMPLE}/metrics/${SAMPLE}_QSD.metrics \n\t\e[94m\e[1m-> \e[0m\e[96m${OUT}/${SAMPLE}/metrics/${SAMPLE}_QSD.pdf\e[0m"
logfile=${OUT}/${SAMPLE}/logs/${SAMPLE}_PicardQualityDist.log
java -d64 -jar $PICARD/QualityScoreDistribution.jar \
  INPUT=${OUT}/${SAMPLE}/${SAMPLE}_bootstrap.bam \
  CHART_OUTPUT=${OUT}/${SAMPLE}/metrics/${SAMPLE}_QSD.pdf \
  OUTPUT=${OUT}/${SAMPLE}/metrics/${SAMPLE}_QSD.metrics \
  REFERENCE_SEQUENCE=${REF} \
  QUIET=T \
  VERBOSITY=ERROR \
  VALIDATION_STRINGENCY=LENIENT \
  2> >(tee "$logfile")

# Breadth of genome coverage
echo -e "\e[91m[6/${STEPS}] BEDtools:Genomecov \n\t\e[94m\e[1m<- \e[0m\e[92m${OUT}/${SAMPLE}/${SAMPLE}_bootstrap.bam \n\t\e[94m\e[1m-> \e[0m\e[96m${OUT}/${SAMPLE}/metrics/${SAMPLE}.dcov\e[0m"
logfile=${OUT}/${SAMPLE}/logs/${SAMPLE}_genomecov.err
bedtools genomecov -ibam ${OUT}/${SAMPLE}/${SAMPLE}_bootstrap.bam \
  -g ${REF}.fai \
  -max 20 \
  > ${OUT}/${SAMPLE}/metrics/${SAMPLE}.dcov \
  2> >(tee "$logfile")

# Poisson distribution relative to genome coverage
echo -e "\e[91m[7/${STEPS}] R:Coverage-Poisson.R \n\t\e[94m\e[1m<- ${OUT}/${SAMPLE}/metrics/${SAMPLE}_GATKcov.sample_summary \n\t\e[94m\e[1m<- ${OUT}/${SAMPLE}/metrics/${SAMPLE}.dcov \n\t\e[94m\e[1m-> \e[0m\e[96m${OUT}/${SAMPLE}/metrics/${SAMPLE}_Coverage_Poisson.pdf\e[0m"
${RSCRIPTS}/Coverage-Poisson.R ${OUT} ${SAMPLE} \
  ${OUT}/${SAMPLE}/metrics/${SAMPLE}.dcov \
  ${OUT}/${SAMPLE}/metrics/${SAMPLE}_GATKcov.sample_summary
rm ${OUT}/${SAMPLE}/metrics/${SAMPLE}.dcov.tmp

# Callable Loci
echo -e "\e[91m[8/${STEPS}] GATK:CallableLoci \n\t\e[94m\e[1m<- \e[0m\e[92m${OUT}/${SAMPLE}/${SAMPLE}_bootstrap.bam \n\t\e[94m\e[1m-> \e[0m\e[96m${OUT}/${SAMPLE}/metrics/${SAMPLE}_callable.summary\e[0m \n\t\e[94m\e[1m-> \e[0m\e[96m${OUT}/${SAMPLE}/metrics/${SAMPLE}_callable.bed\e[0m"
logfile=${OUT}/${SAMPLE}/logs/${SAMPLE}_CallableLoci.err
java -d64 -jar ${GATK}/GenomeAnalysisTK.jar \
  -R ${REF} \
  -T CallableLoci \
  -I ${OUT}/${SAMPLE}/${SAMPLE}_bootstrap.bam \
  -o ${OUT}/${SAMPLE}/metrics/${SAMPLE}_callable.bed \
  --summary ${OUT}/${SAMPLE}/metrics/${SAMPLE}_callable.summary \
  --format BED \
  --minDepth 3 \
  --minDepthForLowMAPQ 4 \
  -l FATAL \
  2> >(tee "$logfile")


 





