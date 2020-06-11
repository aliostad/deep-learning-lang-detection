#!/usr/bin/env bash

wwTag=`showtags | grep WWAnalysis | head -n 1 | awk '{print $1}'`

cat loopOverAll.master | grep ID${1}| while read x; do
    if [ "${x:0:1}" = "#" ] ; then continue;fi
    sampleNum=`echo $x | c 1`
    sampleName=`echo $x | c 2`
    numEvents=`echo $x | c 3`
    evtsPer=`echo $x | c 4`
    isMC=`echo $x | c 5`
    tag=`echo $x | c 6`
    dbsName=`echo $x | c 7`

    mkdir -p $sampleNum.$sampleName

    cat step1to2Lite_cfg.py | \
        sed s/RMMEFN/$sampleName.root/g |  \
        sed s/RMMEMC/$isMC/g |  \
        sed s/RMMEGlobalTag/$tag/g > $sampleNum.$sampleName/$sampleName.py

    if [ "$isMC" = "True" ] ; then
        cat crab.cfg | \
            sed s/RMMEDATASET/${dbsName//\//\\/}/g | \
            sed s/RMMENUM/$sampleNum/g | \
            sed s/RMMENOEVENTS/$numEvents/g | \
            sed s/RMMEEVTSPERJOB/$evtsPer/g | \
            sed s/RMMEPRELABEL/$wwTag/g | \
            sed s/RMMEFN/$sampleName/g > $sampleNum.$sampleName/crab.cfg
    else 
        cat crabData.cfg | \
            sed s/RMMEDATASET/${dbsName//\//\\/}/g | \
            sed s/RMMENUM/$sampleNum/g | \
            sed s/RMMENOEVENTS/$numEvents/g | \
            sed s/RMMEEVTSPERJOB/$evtsPer/g | \
            sed s/RMMEPRELABEL/$wwTag/g | \
            sed s/RMMEFN/$sampleName/g > $sampleNum.$sampleName/crab.cfg
    fi

done
    
