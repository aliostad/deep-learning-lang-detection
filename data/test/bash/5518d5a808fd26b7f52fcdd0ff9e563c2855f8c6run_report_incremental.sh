#!/bin/bash

set -e

# Usage
# ./utils/run_report_incremental.sh - Runs it using the normal training files generated
# OR
# ./utils/run_report_incremental.sh binary - Converts the training files generated to yes/no and then does training

top5=$(cat etc/training_email_ids.csv | head -n5 | awk -F ',' '{print $1}' | sed 's/@.*//' | xargs | tr ' ' '|')
top10=$(cat etc/training_email_ids.csv | head -n10 | awk -F ',' '{print $1}' | sed 's/@.*//' | xargs | tr ' ' '|')
top20=$(cat etc/training_email_ids.csv | head -n20 | awk -F ',' '{print $1}' | sed 's/@.*//' | xargs | tr ' ' '|')

for email_ids in ${top5} ${top10} ${top20}; do 
	echo -e "\n****** Email ids: ${email_ids} ******\n"
	
	find ${HOME}/training_input -type dir | grep -E "(${email_ids})" | xargs python generate_snow_input.py --tf_idf --named_entities --training_file train.snow --emails_file emails.snow --id_mappings_file id_mappings.snow --email_dirs	    
	 
	if [[ $1 == "binary" ]]; then 
		echo -e "\n  ** Converting training file to yes/no training file **\n"
		cat train.snow | python ./utils/generate_binary_training_data.py > tmp.out
		mv tmp.out train.snow
	fi
	 
	cat train.snow | python utils/splitter.py train-chunk     
	for i in 1 2 3 4 5; do
		echo -e "\n  ** Testing with chunk ${i} and training on the rest **\n" 	    	
		
		test_chunk=train-chunk-${i}.snow    	
		ls train-chunk-*.snow | grep -v ${test_chunk} | xargs cat > train-chunk.snow
		
		labels=$(cat train-chunk.snow | ./utils/list_labels)
		  
		for algorithm in W P B; do
			echo -e "\n    ** Testing with algorithm ${algorithm} **\n"
			~/Snow_v3.2/snow -train -I train-chunk.snow -F net.snow -${algorithm}:${labels}	    	
			~/Snow_v3.2/snow -test -i + -I ${test_chunk} -F net.snow
		done
	done
done

