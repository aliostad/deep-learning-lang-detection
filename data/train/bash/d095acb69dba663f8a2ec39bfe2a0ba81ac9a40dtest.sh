#!/bin/sh
mkdir results

for K in 1 2 5 10 
do
	./bin/serelex_i686 -c "sample-data/concepts.csv" -d "sample-data/definitions.csv" -s "sample-data/stoplist.csv" -o "results/overlap_knn_$K.csv" -S o -M 1 -K $K
done

for K in 1 2 5 10 
do
	./bin/serelex_i686 -c "sample-data/concepts.csv" -d "sample-data/definitions.csv" -s "sample-data/stoplist.csv" -o "results/overlap_mutual-knn_$K.csv" -S o -M 2 -K $K
done

for K in 1 2 5 10 
do
	./bin/serelex_i686 -c "sample-data/concepts.csv" -d "sample-data/definitions.csv" -s "sample-data/stoplist.csv" -o "results/cos_knn_$K.csv" -S c -M 1 -K $K
done

for K in 1 2 5 10 
do
	./bin/serelex_i686 -c "sample-data/concepts.csv" -d "sample-data/definitions.csv" -s "sample-data/stoplist.csv" -o "results/cos_mutual-knn_$K.csv" -S c -M 2 -K $K
done