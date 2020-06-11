#! /bin/bash

ffile=$1
rfile=$2 
sample=$(echo ${ffile##*/} | cut -d '_' -f 1)


#echo $sample

# concatenate 
pear -f $ffile -r $rfile -o $sample
echo "------"
# filter by primers
# FR matches
cutadapt --no-trim --discard-untrimmed -g ^CCCTCCACTGGAAATTTGACAAATCGCACCCTGTATCTATCTATCTAT -o $sample.Fca1.fastq $sample.assembled.fastq
echo "------"
cutadapt --no-trim --discard-untrimmed -a TGAAAGAGACCTTGTTGATTG$ -o $sample.matched.fastq $sample.Fca1.fastq
echo "------"
# RF matches
cutadapt --no-trim --discard-untrimmed -g ^GCAATCAACAAGGTCTCTTTCA -o $sample.Rca1.fastq $sample.assembled.fastq
echo "------"
cutadapt --no-trim --discard-untrimmed -a ATAGATAGATAGATACAGGGTGCGATTTGTCAAATTTCCAGTGGAGGG$ -o $sample.Rca2.fastq $sample.Rca1.fastq
echo "------"
# combine
seqtk seq -r $sample.Rca2.fastq >> $sample.matched.fastq
# calculate stats
cat $sample.matched.fastq | awk '{if(NR%4==2) print length($1)}' | sort | uniq -c > $sample.matched.len.txt
cat $sample.matched.fastq | awk '{if(NR%4==2) print length($0) " " $0; }' | sort -n > $sample.matched.lenseq.txt
# clean up
rm $sample.discarded.fastq $sample.unassembled.*.fastq
rm $sample.*ca*fastq