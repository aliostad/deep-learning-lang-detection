#!/bin/bash

SAMPLE_ID=$1
NODE_COUNT=$2

#First check if we gave the FQs to split!
if [ -z ${SAMPLE_ID} ]; then 
	echo "you must define SAMPLE_ID!"; 
	exit
fi

#First check if we said how many nodes...
if [ -z ${NODE_COUNT} ]; then 
	echo "you must define NODE_COUNT!"
	exit
fi

START=$(date +%s)

mkdir -p jobLogs

JOB_PATH=$PWD
SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

mkdir -p ${JOB_PATH}/messages/

echo "Scripts are in ${SCRIPTS_DIR}"

echo "Began $SAMPLE_ID test at `date`" > ./jobLogs/splitbam.${SAMPLE_ID}.timeCount.txt

echo "$START" > ./jobLogs/${SAMPLE_ID}.s

rm -f ${JOB_PATH}/messages/${SAMPLE_ID}.*

FQ1=`echo ${SAMPLE_ID}.R1.QC.fq.gz`
FQ2=`echo ${SAMPLE_ID}.R2.QC.fq.gz`

echo -ne "\nJOB PATH: ${JOB_PATH}\n"

echo "${SAMPLE_ID} ${JOB_PATH}" > ${JOB_PATH}/messages/${SAMPLE_ID}.splitting

splitJob=$(qsub -v SAMPLE_ID=${SAMPLE_ID},FQ1=${FQ1},FQ2=${FQ2},JOB_PATH=${JOB_PATH},NODE_COUNT=${NODE_COUNT},SCRIPTS_DIR=${SCRIPTS_DIR} \
 -N ${SAMPLE_ID}.Split \
 ${SCRIPTS_DIR}/make_split_reads.pbs | cut -f1 -d ".")

echo -ne "\n\nSplitting ${FQ1} ${FQ2} started with job ${splitJob} `date`\n"

crontab -l > currentcrontabs

echo "* * * * * bash ${SCRIPTS_DIR}/tophat2_slit_cronScript.v2.sh ${SAMPLE_ID} ${NODE_COUNT} ${JOB_PATH} >> ${JOB_PATH}/jobLogs/${SAMPLE_ID}.cron.log" >> ${SAMPLE_ID}_cron

cat currentcrontabs >> ${SAMPLE_ID}_cron
crontab ${SAMPLE_ID}_cron

echo -ne "Greetings, you added:\n`cat ${SAMPLE_ID}_cron` \n\nto a cronjob `date`\n\n" > ./jobLogs/${SAMPLE_ID}.cron.log

rm ${SAMPLE_ID}_cron
rm currentcrontabs

echo -ne "\nCron job will pick up from once fastqs are done splitting, just watch the queue explode...\n\n"

sleep 1
echo -ne "\n`qstat | grep ${SAMPLE_ID} | tail -1`\n\n"
 
