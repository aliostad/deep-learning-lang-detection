#!/bin/bash

np_list="1 2 4 8 16 24 32 48 64"
n_list="512 1024 2048 4096 8192 16384"

# Create directories for graphs

mkdir -p ./skif/

# Time

echo "Variation sceme: Making graphs for time measures"

for save_steps in -1 10
do
	if [ "$save_steps" = "10" ]
	then
		subdirname="Time_with_save"
		postfix="withsave"
	else
		subdirname="Time_no_save"
		postfix="nosave"
	fi

	echo -n "Processing ${subdirname}...  "
	
	cat ./graph_var_time_skif.tpl.gp | sed -e "s/#PFX#/${postfix}/" | gnuplot
	
	echo "[Finished]"
done

echo "[Finished]"

