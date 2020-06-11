#!/bin/bash

source analysis.sh

[[ -n $1 ]] && run_cmd=$1

for mc in $mc_samples_to_run; do 
    samples=$(hget $mc samples)
    
    echo "------- Running $samples"
    echo
    for pu in $pileups; do
	pu_options=$(hget $pu opts)
	echo pu_options : ${pu_options}

	for sample in $samples; do
	    pu_sample=$(echo $sample | sed "s%:%_${pu}:%g")
	    sample_name=$(echo $pu_sample | sed 's%:.*%%')

	    echo "Running $sample_name"
	    logfile ${storedir}/${pfx}_${sample_name}.log
	    jobname ${sample_name}
	    $run_cmd ./higgsToGGanalyzer.py ${options} ${mc_options} ${pu_options} -samples $pu_sample -outfile ${storedir}/${pfx}_${sample_name}.root
	    echo 

	done
	
    done
done
