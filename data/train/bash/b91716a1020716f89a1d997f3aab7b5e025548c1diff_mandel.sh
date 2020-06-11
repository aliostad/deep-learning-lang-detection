#!/usr/bin/env zsh
sizes=( 1 2 4 6 8 10 12 16 32 50 64 100 125 250 333 500 1000 2000 4000 8000 )
dims=( 2000 4000 8000 10000)
chunks=( 0 1 2 )
DIR=trans_benchmarks

for dim in $dims
do
    echo "seq ${dim}"
    #seq
    python differ.py ${DIR}/mandelseqwu${dim} ${DIR}/mandelseqtask${dim}

    #transformed
    for size in $sizes
    do
	if [[ $size -gt $dim ]]; then
	    break
	fi
	for chunk in $chunks
	do
	    echo "${dim}x${size}x${chunk}"
	    python differ.py "${DIR}/mandeltranswu${dim}x${size}" "${DIR}/mandeltranstask${dim}x${size}x${chunk}"
	done
    done
done
