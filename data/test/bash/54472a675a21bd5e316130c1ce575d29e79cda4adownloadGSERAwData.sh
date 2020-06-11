#!/bin/bash

if [ $# -lt 2 ]; then
	echo `basename $0` series_matrix_file outdir
	exit 1
fi

series_matrix_file=$1
outdir=$2

mkdir.py $outdir

dequote.sh $series_matrix_file > $outdir/series_matrix.txt

sampleTitles=(`grep Sample_title $outdir/series_matrix.txt`)
for ((i=1;i<${#sampleTitles[@]};i++)); do
	sampleTitle=${sampleTitles[$i]}
	echo new sample $sampleTitle. Create dir
	mkdir.py $outdir/$sampleTitle
done

sampleSupplRows=(`grep Sample_supplementary_file $outdir/series_matrix.txt | tr "\t" "|"`)

for srow in ${sampleSupplRows[@]}; do
	#echo srow $srow

	entries=( `echo $srow | tr "|" "\n" `)
	
	for((i=1;i<${#entries[@]};i++)); do
		entry=${entries[$i]}
		sampleTitle=${sampleTitles[$i]};
		echo "$i new entry ${sampleTitles[$i]} $entry"
		bsub wget -r -nd -P $outdir/$sampleTitle $entry
	done
done