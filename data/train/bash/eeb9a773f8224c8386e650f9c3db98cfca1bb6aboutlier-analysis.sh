#!/bin/bash
#
# Precomputed median, highthreshold and lowthreshold 1.5 IQR values based on CKCC
# reference file target_tcga_RSEM_Hugo_norm_count.tumor.sort
#
# Example:
# ./outlier-analysis.sh SAMPLE_DATA.tsv median.tsv highthreshold.tsv lowthreshold.tsv
#
# output :
# top_5_percent_most_highly_expressed_genes.tsv
#   tab-separated
#   Fields: Gene name, sample expression value
#   Gene names and expression values for the 5% of genes in
#   SAMPLE_DATA with the highest absolute expression values
#
# down_outlier_genes
#   space-separated
#   Fields: gene name, median background value, sample expression value
#   Gene names & values for all genes where SAMPLE_DATA's expression value
#   is lower than the background cohort's "low" threshold.
#
# up_outlier_genes
#   space-separated
#   Fields: gene_name, median background value, sample expression value, sample expression value (again)
#   Gene names & values for genes where SAMPLE_DATA's expression value
#   is higher than the background cohort's "high" threshold. Only includes
#   genes that are ALSO in the top 5% most highly expressed
#######################################################################

sed s/\"//g $2 | sort > median.sort
sort $3 > highthreshold.sort
sort $4 > lowthreshold.sort

mv $1 single_sample

sort single_sample > single_sample.sort
join -1 1 ./highthreshold.sort ./lowthreshold.sort | sed s/\"//g | sort | join -1 1 - ./median.sort |  join -1 1 - ./single_sample.sort > temp

awk '($3>$5){print $1, $4, $5}' temp | sort > down.outlier-single_sample.temp.sort
awk '($2<$5){print $1, $4, $5}' temp > up.outlier-single_sample.temp.sort

gene_count=$(wc -l single_sample | awk '{print $1}')
top_percent=$(printf "%.0f" $(echo "($gene_count - 1) * .05" | bc))
(>&2 echo "gene count: $gene_count")
(>&2 echo "top/bottom 5% number of genes: $top_percent")

sort -r -n -k  2,2 single_sample | head -n $top_percent | sort > single_sample.head.sort
#sort -r -n -k 2,2 single_sample | tail -n $top_percent | sort > single_sample.tail.sort

cat down.outlier-single_sample.temp.sort > down_outlier_genes
join up.outlier-single_sample.temp.sort single_sample.head.sort > up_outlier_genes

# rename for clarity
mv single_sample.head.sort top_5_percent_most_highly_expressed_genes.tsv
#rm temp
#rm *.temp*
#rm *.sort
