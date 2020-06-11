#!bin/bash

fq_dir=/lustre/user/houm/projects/AnnoLnc/CLIP/fastq
logs_dir=${fq_dir}/logs
mkdir -p $logs_dir

function run_fastx_clipper {
	sample=$1
	series=$2
	adaptor=$3
	sample_dir=${fq_dir}/$series
	mkdir -p $sample_dir
	fq_file=$sample_dir/${sample}.fastq
	output_fie=$sample_dir/${sample}_remove_adapter.fastq
	cmd="fastx_clipper -Q33 -a $adaptor -l 20 -v -i $fq_file -o $output_fie"
	echo "Running fastx_clipper for $sample..."
	echo $cmd
	eval $cmd
	echo "Done!"
}

while read s e a
do
	now_date=`date +%y%m%d`
	(echo $now_date
	time run_fastx_clipper $s $e $a) 2>&1 | tee $logs_dir/${now_date}-${s}_remove_adapter.log
	echo "================================================="
done