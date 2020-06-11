#!/bin/bash

#models="NorESM1-M CNRM-CM5 CSIRO-Mk3-6-0 CanESM2 MIROC5 bcc-csm1-1-m HadGEM2-CC365 HadGEM2-ES365 CCSM4 IPSL-CM5A-MR"
scenarios="historical rcp45 rcp85"

models="MIROC5"
#scenarios="rcp45"
chunks="chunk1 chunk2 chunk3" 
#chunks="chunk1" 

for model in $models
do
        for scenario in $scenarios
        do
	if [ "historical" = "$scenario" ]
	then 
                echo "processing $model $scenario"
                qsub -v chunk="junkchunk",model=$model,scenario=$scenario qsub_fast_calc_dfm.sh 
        else 
		for chunk in $chunks
		do 
			echo "processing $model $scenario $chunk" 
			qsub -v chunk=$chunk,model=$model,scenario=$scenario qsub_fast_calc_dfm.sh 
		done  
	fi 
	done
done

