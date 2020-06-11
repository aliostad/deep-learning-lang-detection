source params.dat
echo "Generating the script to draw graphs"
#generate the script to draw the graphs
echo "set term post eps" >> $path_to_save/to_plot.plt
for ((  i = $mu_start;  i <= $mu_end;  i *= $step ))
do
for ((  n = $n_threads_start;  n <= $n_threads_end;  n += 2 ))
do
echo -n "set output '$path_to_save/comparison_d_$if_deterministic" >> $path_to_save/to_plot.plt
echo -n "_$n" >> $path_to_save/to_plot.plt
echo "_threads_$i.ps'" >> $path_to_save/to_plot.plt

echo -n "plot '$path_to_save/comparison_d_$if_deterministic" >> $path_to_save/to_plot.plt
echo -n "_$n" >> $path_to_save/to_plot.plt
echo -n "_threads_$i' using 1:2 with lines, '$path_to_save/comparison_d_$if_deterministic" >> $path_to_save/to_plot.plt
echo -n "_$n" >> $path_to_save/to_plot.plt
echo "_threads_$i' using 1:3 with lines" >> $path_to_save/to_plot.plt
done
done
#graph the graphs
echo "drawing the graphs"
gnuplot $path_to_save/to_plot.plt

