#!/bin/sh

#  normalised_bigWigs.sh
#  
#
#  Created by Peter Crisp on 6/01/2016.
#

#This code will use the bed and bedgraph files from the standard RNAseq pipeline and normalise them to total coverage per 10 Billion base pair depth.
#Steps:
#1 determine total base pair counts by suming counts in spliced bed file
#2 normalise bedgraph file (.bg) to 10000000000 (10B) / total counts
#3 remake bigWigs.

cd tdf_for_igv
for SAMPLE in `ls`;
do
echo $SAMPLE
norm1=10000000000
echo normalisation reference $norm1
var1=`awk '{ SUM += $3} END { print SUM}' $SAMPLE/$SAMPLE.plus.bed`
var2=`awk '{ SUM += $3} END { print SUM}' $SAMPLE/$SAMPLE.minus.bed`
var3=$(echo "$var1 + $var2 * -1" | bc)
echo total bp counts are $var3
var4=$(echo " scale=4; $norm1 / $var3" | bc)
echo normalisation factor is $var4

echo writing new bedgraphs .bg file
awk -v sum=$var4 '{print $1"\t"$2"\t"$3"\t"$4*sum}' $SAMPLE/$SAMPLE.plus.bg \
> $SAMPLE/$SAMPLE.norm.plus.bg
awk -v sum=$var4 '{print $1"\t"$2"\t"$3"\t"$4*sum}' $SAMPLE/$SAMPLE.minus.bg \
> $SAMPLE/$SAMPLE.norm.minus.bg

echo making bigWigs
bedGraphToBigWig $SAMPLE/$SAMPLE.norm.plus.bg \
/home/pete/ws/refseqs/TAIR10/TAIR10_gen_chrc.chrom.sizes \
$SAMPLE/$SAMPLE.norm.plus.bigWig

bedGraphToBigWig $SAMPLE/$SAMPLE.norm.minus.bg \
/home/pete/ws/refseqs/TAIR10/TAIR10_gen_chrc.chrom.sizes \
$SAMPLE/$SAMPLE.norm.minus.bigWig
done