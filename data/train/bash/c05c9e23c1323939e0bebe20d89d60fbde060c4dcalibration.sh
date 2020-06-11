#!/bin/bash -x

cd $(dirname $0)

make

prog_name=clock_gettime_pthread
tracer_name=calibration
no_threads=($(grep no_thread < ${tracer_name}.param))
no_threads=${no_threads[@]:1}
sample_sizes=($(grep sample_size < ${tracer_name}.param))
sample_sizes=${sample_sizes[@]:1}

echo "mean,std,no_thread,sample_size" > ${prog_name}_${tracer_name}.csv
function save_stats {
    mean=($(grep mean < statistics))
	std=($(grep std < statistics))
	echo "${mean[1]},${std[1]},$no_thread,$sample_size" >> ${prog_name}_${tracer_name}.csv
}

for no_thread in $no_threads; do
	for sample_size in $sample_sizes; do
		./$prog_name -s $sample_size -t $no_thread
		save_stats
	done
done
