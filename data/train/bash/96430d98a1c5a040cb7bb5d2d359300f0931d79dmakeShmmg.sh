#  Copyright Human Genome Center, Institute of Medical Science, the University of Tokyo
#  @since 2012

#! /bin/bash
#$ -S /bin/bash
#$ -cwd

SAMPLE=$1
TYPE1=$2
TYPE2=$3
TARGETDIR=$4
TOTALDIR=$5
SCRIPTDIR=$6
R=$7
CN_SCRIPTDIR=$8

source ${SCRIPTDIR}/utility.sh

sh ${SCRIPTDIR}/sleep.sh


echo "perl ${CN_SCRIPTDIR}/makeHMMinput2.pl ${TARGETDIR}/${SAMPLE}.fa ${TARGETDIR}/${SAMPLE}.as_count.bait ${TOTALDIR}/${TYPE1}.count ${TOTALDIR}/${TYPE2}.count > ${TARGETDIR}/${SAMPLE}.${TYPE2}.shmmg"
perl ${CN_SCRIPTDIR}/makeHMMinput2.pl ${TARGETDIR}/${SAMPLE}.fa ${TARGETDIR}/${SAMPLE}.as_count.bait ${TOTALDIR}/${TYPE1}.count ${TOTALDIR}/${TYPE2}.count > ${TARGETDIR}/${SAMPLE}.${TYPE2}.shmmg
check_error $?


echo "${R} --vanilla --slave --args ${TARGETDIR}/${SAMPLE}.${TYPE2} < ${CN_SCRIPTDIR}/CBS.R"
${R} --vanilla --slave --args ${TARGETDIR}/${SAMPLE}.${TYPE2} < ${CN_SCRIPTDIR}/CBS.R
check_error $?


: <<'#__COMMENT_OUT__'
#__COMMENT_OUT__


