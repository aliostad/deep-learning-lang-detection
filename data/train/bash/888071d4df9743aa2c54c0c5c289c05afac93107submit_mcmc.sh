#!/bin/bash

mkdir -v scripts

#for mass in {1..5}
#do
#	for channel in 1 2 #2 #1
#	do
#		for slope in {1..3}
#		do
#			for mag in 13 21 32 4 5 #13 21 32 4 5
#			do
			for model in 11113 12132h
				do
#				model=${mass}${channel}${slope}${mag}"h"
				echo $model
				# ls "data/maps/ns0128/haze_model_54*${model}*"
				cp test_run.pbs scripts/run_$model.pbs
				tmpfile="scripts/run_${model}.pbs"
				sed "9 c\#PBS -N mcmc_DM_${model}" -i ${tmpfile}
				sed "10 c\#PBS -e mcmc_DM_${model}.err" -i ${tmpfile}
				sed "11 c\#PBS -o mcmc_DM_${model}.out" -i ${tmpfile}
				sed "19 c\pbsdsh /global/scratch2/sd/dpietrob/DM-haze/scripts/runtask_${model}.sh" -i ${tmpfile}

				cp runtask.sh scripts/runtask_$model.sh
				tmpfile="scripts/runtask_$model.sh"
				sed "17 c\model=${model}" -i ${tmpfile}
				
				qsub scripts/run_$model.pbs
			done
#		done
#	done
#done