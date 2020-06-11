#! /bin/bash

# Script to make the QC json files

if [ $# -lt 1 ]; then
	echo "USAGE: bash mkQC_json.sh /path/to/project"
	exit 8
fi

PROJECT_DIR="$1"

samples=`find ${PROJECT_DIR}/* -maxdepth 0 -type d`

for sample in $samples; do
	sample_name=`basename $sample`
	READY="True"
	runs=`find ${sample}/Run* -maxdepth 0 -type d`
	for run in $runs; do
		run_name=`basename $run`
		if [ ! "`find ${run}/4.2*.vcf -maxdepth 0 -type f 2>/dev/null`" -a ! "`find ${run}/tvc*out/TSVC_variants.vcf -maxdepth 0 -type f 2>/dev/null`" ]; then
			READY="False"
#			if [ ! "`find ${run}/tvc*out -maxdepth 0 -type d 2>/dev/null`" ]; then
#				echo "$run did not attempt tvc"
#				json=`find ${run}/*.json_read -type f 2>/dev/null`
#				mv ${run}/*.json_read ${run}/${sample_name}_${run_name}.json 2>/dev/null
#				:
#			else
#				echo "${run} had an error with tvc. moving back to .json"
#				mv ${run}/*.json_read ${run}/${sample_name}_${run_name}.json 2>/dev/null
#			fi
#			#echo "Removing $sample/QC"
#			exit
#			#rm -r ${sample}/QC
		fi
	done
	# If this sample is ready to be QCd, then write the Json file
	if [ "$READY" == "True" ]; then
		rm -r ${sample}/QC
#		if [ ! "`find ${sample}/QC/*.json* -maxdepth 0 -type f 2>/dev/null`" ]; then
		mkdir ${sample}/QC 2>/dev/null
		./writeQCJson.py $sample 
		exit
#		else
#			json=`find ${sample}/QC/*.json* -maxdepth 0 -type f`
#			echo "mv ${json} ${sample}/QC/${sample_name}_QC.json"
#			mv ${sample}/QC/*.json* ${sample}/QC/${sample_name}_QC.json
#		fi
#	else
#		echo "$sample/QC is not ready for QC"
#		rm -r ${sample}/QC
	fi
done
