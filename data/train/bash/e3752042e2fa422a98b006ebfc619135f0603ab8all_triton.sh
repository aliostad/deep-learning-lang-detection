#!/bin/sh

if [ $# != 3 ] ; then
        echo "
Usage: 

./all-triton.sh <input-dir> <dataset-dir> <cdf-name>

Commonly used CDFs:
HGU133Plus2_Hs_ENSG (Marioni, FIMM)
HGU133A2_Hs_ENSG	(Lungs_C)
HuEx10stv2_Hs_ENSG	(Lungs_S, brain)
HGFocus_Hs_ENSG		(Cheung)
"
        exit 1
fi


input_dir=$1
dataset_dir=$2
cdf=$3

for i in $input_dir/* ; do
	SAMPLE=`basename $i`
	sbatch -o ./logs/$SAMPLE.log -e ./logs/$SAMPLE.err ./run_triton.sh $input_dir/$SAMPLE $cdf $input_dir/$SAMPLE/$SAMPLE.gene.mmseq $dataset_dir/array_expr_means.RData
done
