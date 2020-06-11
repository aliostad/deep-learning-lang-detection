#!/bin/bash

#copy passed in sample names                                                    
samples=""                                                                      
for var in "$@"                                                                 
do                                                                              
        samples="$samples $var"                                                 
done 

printf "" > multi_sample.report

for sample in $samples
do
		cat $sample.multi_sample.report >> multi_sample.report
done	