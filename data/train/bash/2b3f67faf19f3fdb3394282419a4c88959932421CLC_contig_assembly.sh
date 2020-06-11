#!/bin/bash
#author: Tobias Hofmann
#assembly of contigs with CLC-AssemblyCell
#use this script with the sample ID as input argument. Trimmed files have to be stored in the executing path in this format: ID/ID-READ1.fastq ID/ID-READ2.fastq
sample=$(basename "$1");
mkdir $sample-results;
echo "start assembly of $sample";
/state/partition3/CLC-AssemblyCell/clc-assembly-cell-4.3.0-linux_64/clc_assembler --cpus 24 -o $sample-results/$sample-contigs.fst -e $sample-results/$sample-fragment-size_info.txt -p fb ss 200 800 -q -i $sample/$sample-READ1.fastq $sample/$sample-READ2.fastq; 
#mapping
echo "start mapping reads against contigs of $sample";
/state/partition3/CLC-AssemblyCell/clc-assembly-cell-4.3.0-linux_64/clc_mapper --cpus 24 -o $sample-results/$sample.cas -p fb ss 200 800 -q -i $sample/$sample-READ1.fastq $sample/$sample-READ2.fastq -d $sample-results/$sample-contigs.fst;
#info
echo "creating info files for $sample";
/state/partition3/CLC-AssemblyCell/clc-assembly-cell-4.3.0-linux_64/clc_mapping_info -c -n $sample-results/$sample.cas > $sample-results/$sample-mapping_info.txt;
/state/partition3/CLC-AssemblyCell/clc-assembly-cell-4.3.0-linux_64/clc_sequence_info -l -k -n $sample-results/$sample-contigs.fst > $sample-results/$sample-sequence_info.txt;
/state/partition3/CLC-AssemblyCell/clc-assembly-cell-4.3.0-linux_64/clc_sequence_info -l -k -n -c 200 $sample-results/$sample-contigs.fst > $sample-results/$sample-sequence_info_200.txt;
/state/partition3/CLC-AssemblyCell/clc-assembly-cell-4.3.0-linux_64/clc_sequence_info -l -k -n -c 500 $sample-results/$sample-contigs.fst > $sample-results/$sample-sequence_info_500.txt;
/state/partition3/CLC-AssemblyCell/clc-assembly-cell-4.3.0-linux_64/clc_sequence_info -l -k -n -c 1000 $sample-results/$sample-contigs.fst > $sample-results/$sample-sequence_info_1000.txt;
/state/partition3/CLC-AssemblyCell/clc-assembly-cell-4.3.0-linux_64/clc_sequence_info -l -k -n -c 5000 $sample-results/$sample-contigs.fst > $sample-results/$sample-sequence_info_5000.txt;
echo "**********finished with $sample**********";
