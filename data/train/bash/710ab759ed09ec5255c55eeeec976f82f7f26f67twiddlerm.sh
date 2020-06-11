#!/bin/bash

if [ $# -ne 1 ]
then
        echo -e
        echo -e "Usage:"
        echo -e "\t twiddlerem.sh /path/to/suidlistfile.txt"
        echo -e
        exit
fi

TWIDDLEPATH=/export/dcm4chee/bin/twiddle.sh
TWUSER=admin
TWPASS=password
TWHOST=127.0.0.1
INPUTFILE=$1

while read iuid
do

   echo ${iuid}

#   ${TWIDDLEPATH} -s ${TWHOST} -u ${TWUSER} -p ${TWPASS} invoke "dcm4chee.archive:group=ONLINE_STORAGE,service=FileSystemMgt" scheduleStudyForDeletion ${iuid}

#   ${TWIDDLEPATH} -s ${TWHOST} -u ${TWUSER} -p ${TWPASS} invoke "dcm4chee.archive:group=NEARLINE_STORAGE,service=FileSystemMgt" scheduleStudyForDeletion ${iuid}

#    ${TWIDDLEPATH} -s ${TWHOST} -u ${TWUSER} -p ${TWPASS} invoke "dcm4chee.archive:service=ContentEditService" moveStudyToTrash ${iuid}

   sleep 1

done < $INPUTFILE

