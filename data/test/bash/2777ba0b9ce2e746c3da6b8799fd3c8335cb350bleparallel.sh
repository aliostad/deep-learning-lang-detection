#!/bin/bash

n=24
step=2
grid=4000
time=100

unset GOMP_CPU_AFFINITY

for ((process=1;process<=$n;process+=$step))
do
	for ((i=0;i<5;i++))
	do
		./cf_gcc_f $grid $grid $time $process >> cf_gcc_f.txt
		./cf_icc_f $grid $grid $time $process >> cf_icc_f.txt
		./cf_gcc_d $grid $grid $time $process >> cf_gcc_d.txt
		./cf_icc_d $grid $grid $time $process >> cf_icc_d.txt
		./cf_icc_sse_f $grid $grid $time $process >> cf_icc_sse_f.txt
		./cf_icc_sse_d $grid $grid $time $process >> cf_icc_sse_d.txt
		./cf_icc_avx_f $grid $grid $time $process >> cf_icc_avx_f.txt
		./cf_icc_avx_d $grid $grid $time $process >> cf_icc_avx_d.txt
	done
	echo "" >> cf_gcc_f.txt
	echo "" >> cf_icc_f.txt
	echo "" >> cf_gcc_d.txt
	echo "" >> cf_icc_d.txt
	echo "" >> cf_icc_sse_f.txt
	echo "" >> cf_icc_sse_d.txt
	echo "" >> cf_icc_avx_f.txt
	echo "" >> cf_icc_avx_d.txt
done

export GOMP_CPU_AFFINITY="0-$n"

for ((process=1;process<=$n;process+=$step))
do
	for ((i=0;i<5;i++))
	do
		./cf_gcc_f $grid $grid $time $process >> cf_gcc_f_aff.txt
		./cf_icc_f $grid $grid $time $process >> cf_icc_f_aff.txt
		./cf_gcc_d $grid $grid $time $process >> cf_gcc_d_aff.txt
		./cf_icc_d $grid $grid $time $process >> cf_icc_d_aff.txt
		./cf_icc_sse_f $grid $grid $time $process >> cf_icc_sse_f_aff.txt
		./cf_icc_sse_d $grid $grid $time $process >> cf_icc_sse_d_aff.txt
		./cf_icc_avx_f $grid $grid $time $process >> cf_icc_avx_f_aff.txt
		./cf_icc_avx_d $grid $grid $time $process >> cf_icc_avx_d_aff.txt
	done
	echo "" >> cf_gcc_f_aff.txt
	echo "" >> cf_icc_f_aff.txt
	echo "" >> cf_gcc_d_aff.txt
	echo "" >> cf_icc_d_aff.txt
	echo "" >> cf_icc_sse_f_aff.txt
	echo "" >> cf_icc_sse_d_aff.txt
	echo "" >> cf_icc_avx_f_aff.txt
	echo "" >> cf_icc_avx_d_aff.txt
done

echo "OK"
