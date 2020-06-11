#!/bin/sh

if [ $# != 4 ];
then
	echo "Usage: <output_dir> <TempReports> <sample> <run_info> ";
else
	set -x
	echo `date`
	output_dir=$1
	TempReports=$2
	sample=$3
	run_info=$4
	tool_info=$( cat $run_info | grep -w '^TOOL_INFO' | cut -d '=' -f2)
	chrs=$( cat $run_info | grep -w '^CHRINDEX' | cut -d '=' -f2)
	chrIndexes=$( echo $chrs | tr ":" "\n" )
	variant_type=$( cat $run_info | grep -w '^VARIANT_TYPE' | cut -d '=' -f2)
	variant_type=`echo "$variant_type" | tr "[a-z]" "[A-Z]"`
	i=1
	for chr in $chrIndexes
	do
		chrArray[$i]=$chr
		let i=i+1
	done
	
	if [ $variant_type == "BOTH" -o $variant_type == "SNV" ]
	then
		touch $output_dir/Reports_per_Sample/$sample.SNV.report
		cat $TempReports/$sample.chr${chrArray[1]}.SNV.report >> $output_dir/Reports_per_Sample/$sample.SNV.report
		sed -i '1d;2d' $TempReports/$sample.chr${chrArray[1]}.SNV.report 
		for j in $(seq 2 ${#chrArray[@]})
		do
			sed -i '1d;2d' $TempReports/$sample.chr${chrArray[$j]}.SNV.report
			cat $TempReports/$sample.chr${chrArray[$j]}.SNV.report >> $output_dir/Reports_per_Sample/$sample.SNV.report
		done
	fi
	if [ $variant_type == "BOTH" -o $variant_type == "INDEL" ]
	then
		touch $output_dir/Reports_per_Sample/$sample.INDEL.report
		cat $TempReports/$sample.chr${chrArray[1]}.INDEL.report >> $output_dir/Reports_per_Sample/$sample.INDEL.report
		sed -i '1d;2d' $TempReports/$sample.chr${chrArray[1]}.INDEL.report
		for j in $(seq 2 ${#chrArray[@]})
		do
			sed -i '1d;2d' $TempReports/$sample.chr${chrArray[$j]}.INDEL.report
			cat $TempReports/$sample.chr${chrArray[$j]}.INDEL.report >> $output_dir/Reports_per_Sample/$sample.INDEL.report
		done
	fi
	echo `date`
fi	