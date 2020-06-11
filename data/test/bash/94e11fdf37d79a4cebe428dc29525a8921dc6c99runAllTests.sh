#!/bin/bash

#Simply a loop which modifies the traffic workload (frequency calculation done using freqs.bc)
load=10;

if [ ! -d results$1 ]; then
 mkdir results$1
fi

for i in 0.000070656 0.000035328 0.000023552 0.000017664 0.000014131 0.000011776 0.000010093
do
	echo -n "**.messageFreq = exponential($i" > params.ini
	echo "s)" >> params.ini
	echo "Running simulation..."
	./lanzador.sh 1 $1 10 $load > results$1/test10G-load$load
	echo -e "$(date +'(%d/%b/%y , %T)') Test 1L@10G $load% load: Simulation completed.\n"
	echo "Running simulation..."
	./lanzador.sh 2 $1 1 $load > results$1/test1G-load$load
	echo -e "$(date +'(%d/%b/%y , %T)') Test 10L@1G $load% load: Simulation completed.\n"
	load=$((load + 10))
done
