#!/bin/bash

#copy passed in sample names                                                    
samples=""                                                                      
for var in "$@"                                                                 
do                                                                              
        samples="$samples $var"                                                 
done          
compilers="clang gcc"
features="cpc mc bbcp"
file="multi_sample.report"

#clear file
printf "" > $file

#samples that won't work
broken=""

#Isocompiler modulation, Bloom/Jaccard
for sample in $samples
do
	for compiler in $compilers
	do
		for feature in $features
		do
			printf "Generating isocompiler modulation test report for \
($sample,$compiler,$feature-bloom)\n"
			./view_isocomp_results_bloom.sh $sample $compiler $feature >> $file
			if [ $? -eq 1 ]; then
				broken+=$sample
				broken+=" "
				printf "Missing data for ($sample,$compiler,$feature-bloom)\n"
			fi
		done
	done
done

#Isocompiler modulation, edit distance
for sample in $samples
do
	for compiler in $compilers
	do
		printf "Generating isocompiler modulation test report for \
($sample,$compiler,cpc-edit)\n"
		./view_isocomp_results_edit.sh $sample $compiler >> $file
		if [ $? -eq 1 ]; then
			broken+=$sample
			broken+=" "
			printf "Missing data for ($sample,$compiler,cpc-edit)\n"
		fi
	done
done

#Different compiler, Bloom/Jaccard
for sample in $samples
do
	for feature in $features
	do
		printf "Generating different compiler test report for \
($sample,$feature-bloom)\n"
		./view_diffcomp_results_bloom.sh $sample $feature >> $file
		if [ $? -eq 1 ]; then
			broken+=$sample
			broken+=" "
			printf "Missing data for ($sample,$feature-bloom)\n"
		fi
	done
done

#Different compiler, edit distance
for sample in $samples
do
	printf "Generating different compiler test report for ($sample,cpc-edit)\n"
	./view_diffcomp_results_edit.sh $sample >> $file
	if [ $? -eq 1 ]; then
		broken+=$sample
		broken+=" "
		printf "Missing data for ($sample,cpc-edit)\n"
	fi
done

if [ "$broken" != "" ]; then
	printf "The following test samples are missing data: $broken"
fi