#generate model results

#generate experiment results
n_threads=8
path_to_save=./try
if_deterministic=0
mu_start=100
mu_end=1000000
step=10
lambda_start=$(($mu_start/$step))
#to be changed to appropriate command later
command_to_run=echo 

#Delete previously generated data
rm $path_to_save/*
rm $path_to_save/*.*

#Generate data from the model
for ((  i = $mu_start;  i <= $mu_end;  i *= $step ))
do
	./machine_repairman.py --steps $step -l $lambda_start $i -m $i $i -t $n_threads $n_threads > $path_to_save/to_delete_model_$n_threads\_threads_$i
done

#Run the experiment
for ((  i = $mu_start;  i <= $mu_end;  i *= $step ))
do
	for ((  j = i/$step;  j <= i;  j += i/$step ))
do
	$command_to_run $j $i $if_deterministic >> $path_to_save/to_delete_d_$if_deterministic\_$n_threads\_threads_$i
done
done

#post processing of the data
for ((  i = $mu_start;  i <= $mu_end;  i *= $step ))
do
	#for ((  j = i/$step;  j <= i;  j += i/$step ))
#do
	#$command_to_run $j $i $if_deterministic >> $path_to_save/to_delete_d_$if_deterministic\_$n_threads\_threads_$i
	cut -d ' ' -f1,2 $path_to_save/to_delete_d_$if_deterministic\_$n_threads\_threads_$i > $path_to_save/tmp1
	cut -d ' ' -f1 $path_to_save/to_delete_model_$n_threads\_threads_$i > $path_to_save/tmp2
	paste $path_to_save/tmp1 $path_to_save/tmp2 > $path_to_save/to_delete_comparison_d_$if_deterministic\_$n_threads\_threads_$i
#done
done

#generate the script to draw the graphs
echo "set term post eps" >> $path_to_save/to_plot.plt
for ((  i = $mu_start;  i <= $mu_end;  i *= $step ))
do
	#for ((  j = i/$step;  j <= i;  j += i/$step ))
#do
	echo -n "set output '$path_to_save/to_delete_comparison_d_$if_deterministic" >> $path_to_save/to_plot.plt
	echo -n "_$n_threads" >> $path_to_save/to_plot.plt
	echo "_threads_$i.ps'" >> $path_to_save/to_plot.plt

	echo -n "plot '$path_to_save/to_delete_comparison_d_$if_deterministic" >> $path_to_save/to_plot.plt
	echo -n "_$n_threads" >> $path_to_save/to_plot.plt
	echo -n "_threads_$i' using 1:3 with lines, '$path_to_save/to_delete_comparison_d_$if_deterministic" >> $path_to_save/to_plot.plt
	echo -n "_$n_threads" >> $path_to_save/to_plot.plt
	echo "_threads_$i' using 1:3 with lines" >> $path_to_save/to_plot.plt
	done
#	done
#graph the graphs
gnuplot $path_to_save/to_plot.plt
