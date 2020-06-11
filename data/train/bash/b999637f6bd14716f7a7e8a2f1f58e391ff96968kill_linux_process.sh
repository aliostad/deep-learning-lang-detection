#!/bin/bash

if [ $# -ne 1 ] ; then
        echo "Usage: $0 <Keyword>"
        exit 1
fi

KEY_WORD=${1}
PROCESS_TO_BE_KILL=${0}.ini

ps -ef | grep ${KEY_WORD} > ${PROCESS_TO_BE_KILL} 

while read PROCESS_INFO
do
    echo $PROCESS_INFO > ${0}.toBeKilled

    cat ${0}.toBeKilled | grep "${0}"  > ${0}.toBeIgnore

    if [ -s ${0}.toBeIgnore ]
    then
        echo "========================"
        echo $PROCESS_INFO
    else   
        PROCESS_ID=` cat ${0}.toBeKilled | awk '{print $2}' `
        echo ${PROCESS_ID}
        kill -9 ${PROCESS_ID} 
    fi

done < ${PROCESS_TO_BE_KILL}

exit 0
