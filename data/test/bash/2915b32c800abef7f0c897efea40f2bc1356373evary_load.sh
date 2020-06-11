# !bin/bash
cd /home/lm111/13-LADIS/src/sim
mkdir sim_results/vary_load

for i in {7..7}; do
	mkdir sim_results/vary_load/$i
	for j in 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3; do
		mkdir sim_results/vary_load/$i/$j
		cat sim_config/config_file_template | sed 's/workload:[0-9]*.[0-9]*/workload:'$j'/' > sim_config/config_file_tmp
		cat sim_config/config_file_tmp | sed 's/policy_id:[0-9]*/policy_id:'$i'/' > sim_config/config_file
		./sim -u Cmdenv
		cp sim_config/config_file sim_results/vary_load/$i/$j/
		cp results_file sim_results/vary_load/$i/$j/
		cp -r results sim_results/vary_load/$i/$j/ 
	done
done
