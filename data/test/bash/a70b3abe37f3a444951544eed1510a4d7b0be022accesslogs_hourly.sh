#!/bin/bash
#Hourly access log roll-ups to Hive

jobName="Access Hourly"
processTimeFile="/home/user/states/access_hourly.state"
logFile="/home/user/logs/access_hourly.log"
email="user@domain.com"
pigScript="/home/user/pig/accesslogs_hive_job_combined_hourly.pig"

function lockFile {
    mv "$processTimeFile" "$processTimeFile.lock"
}

function unlockFile {
    mv "$processTimeFile.lock" "$processTimeFile"
}

function checkProcessTime {
    if [ -z "$processTime" ]; then
        echo "The process time cannot be read, try $errorCounter." | mail -s "$jobName Job Time Corrupt" -r hosting-hadoop-noreply@`hostname -f` $email 2>> $logFile
        return 1
    else
        return 0
    fi

}

function readTimeFile {
    if [ ! -f "$processTimeFile" ]; then
        echo "Can not find $processTimeFile, try $errorCounter." | mail -s "$jobName Job State File Missing" -r hosting-hadoop-noreply@`hostname -f` $email 2>> $logFile
        return 1
    else
        return 0
    fi
}

function setProcessTime {
    errorCounter=0

    while [ $errorCounter -lt 7 ];
    do
        readTimeFile
        if [ $? -eq 0 ]; then
            processTime=$(date --date="$(cat $processTimeFile)" '+%Y-%m-%d %H:00 %z')
            checkProcessTime
            if [ $? -eq 0 ]; then
                break
            else
                sleep 180
            fi
        else
            sleep 180
        fi
        errorCounter=$[$errorCounter + 1]
    done

    if [ $errorCounter -lt 7 ]; then
        return 0
    else
        return 1
    fi
}

function runPigScript {
    errorCounter=0

    while [ $errorCounter -lt 7 ];
    do
        pig -stop_on_failure -useHCatalog -param PROCESSTIME="$processTime" $pigScript
        if [ $? -eq 0 ]; then
            processTime=$(date --date="$processTime 60 minutes" '+%Y-%m-%d %H:00 %z')
            printf "$processTime\n" > "$processTimeFile.lock"
            break
        else
            echo "The script did not process correctly for $processTime, try $errorCounter." | mail -s "$jobName Pig Script Update Failed" -r hosting-hadoop-noreply@`hostname -f` $email 2>> $logFile
            sleep 180
        fi
        errorCounter=$[$errorCounter + 1]
    done

    if [ $errorCounter -lt 7 ]; then
        return 0
    else
        return 1
    fi
}

setProcessTime
if [ $? -eq 0 ]; then
    lockFile
    runPigScript
    if [ $? -eq 0 ]; then
        unlockFile
    fi
fi
