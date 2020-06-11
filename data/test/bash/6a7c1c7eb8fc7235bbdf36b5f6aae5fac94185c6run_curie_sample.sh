#!/bin/bash

. job_pool.sh

echoinred() {
	echo -e '\e[0;31m'"$@"
	tput sgr0
}
# afficher en bleu le premier parametre
echoinblue() {
	echo -e '\e[0;34m'"$@"
	tput sgr0
}


input_files="../data/CEA-curie_sample/predicted_swf/*.swf ../data/CEA-curie_sample/original_swf/*.swf"
# input_files="./pyss/src/sample_input ./pyss/src/5K_sample"

simulated_files_dir=../data/CEA-curie_sample/simulated_swf
# simulated_files_dir=simulated_swf

# final_csv_file=../data/CEA-curie/results.csv
final_csv_file=results.csv

algos="EasySJBFScheduler EasyBackfillScheduler"


PROCS=$(($(grep -c ^processor /proc/cpuinfo)))

# initialize the job pool to allow $PROCS parallel jobs and echo commands
job_pool_init $PROCS 1


mkdir -p $simulated_files_dir

echoinred "==== RUNNING SIMULATIONS ===="


job_pool_run ../predictor.py ../../data/CEA-curie_sample/original_swf/curie_sample.swf ../../data/CEA-curie_sample/original_swf/extracted_features_curie_sample sgd squared_epsilon_insensitive l2 onehot 86400 93312   >out
job_pool_run ../predictor.py ../../data/CEA-curie_sample/original_swf/curie_sample.swf ../../data/CEA-curie_sample/original_swf/extracted_features_curie_sample sgd squared_epsilon_insensitive l1 onehot 86400 93312   >out
job_pool_run ../predictor.py ../../data/CEA-curie_sample/original_swf/curie_sample.swf ../../data/CEA-curie_sample/original_swf/extracted_features_curie_sample sgd squared_epsilon_insensitive elasticnet onehot 86400 93312   >out
job_pool_run ../predictor.py ../../data/CEA-curie_sample/original_swf/curie_sample.swf ../../data/CEA-curie_sample/original_swf/extracted_features_curie_sample sgd squared_loss l2 onehot 86400 93312   >out
job_pool_run ../predictor.py ../../data/CEA-curie_sample/original_swf/curie_sample.swf ../../data/CEA-curie_sample/original_swf/extracted_features_curie_sample sgd squared_loss l1 onehot 86400 93312   >out
job_pool_run ../predictor.py ../../data/CEA-curie_sample/original_swf/curie_sample.swf ../../data/CEA-curie_sample/original_swf/extracted_features_curie_sample sgd squared_loss elasticnet onehot 86400 93312   >out
job_pool_run ../predictor.py ../../data/CEA-curie_sample/original_swf/curie_sample.swf ../../data/CEA-curie_sample/original_swf/extracted_features_curie_sample sgd huber l2 onehot 86400 93312   >out
job_pool_run ../predictor.py ../../data/CEA-curie_sample/original_swf/curie_sample.swf ../../data/CEA-curie_sample/original_swf/extracted_features_curie_sample sgd huber l2 onehot 86400 93312   >out
job_pool_run ../predictor.py ../../data/CEA-curie_sample/original_swf/curie_sample.swf ../../data/CEA-curie_sample/original_swf/extracted_features_curie_sample sgd huber l1 onehot 86400 93312   >out
job_pool_run ../predictor.py ../../data/CEA-curie_sample/original_swf/curie_sample.swf ../../data/CEA-curie_sample/original_swf/extracted_features_curie_sample sgd epsilon_insensitive elasticnet onehot 86400 93312   >out
job_pool_run ../predictor.py ../../data/CEA-curie_sample/original_swf/curie_sample.swf ../../data/CEA-curie_sample/original_swf/extracted_features_curie_sample sgd epsilon_insensitive l1 onehot 86400 93312   >out
job_pool_run ../predictor.py ../../data/CEA-curie_sample/original_swf/curie_sample.swf ../../data/CEA-curie_sample/original_swf/extracted_features_curie_sample sgd epsilon_insensitive elasticnet onehot 86400 93312   >out


# wait until all jobs complete before continuing
job_pool_wait
# don't forget to shut down the job pool
job_pool_shutdown

# check the $job_pool_nerrors for the number of jobs that exited non-zero
echo "job_pool_nerrors: ${job_pool_nerrors}"

echo "__OK__"



