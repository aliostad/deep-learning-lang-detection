#!/bin/bash
#author: Tobias Hofmann
#give sample file name as first input in commandline and your reference file name as second
input=$(basename "$1");
sample3=$(echo "$input" | sed 's/-contigs//');
sample2=$(echo "$sample3" | sed 's/.fasta//');
sample=$(echo "$sample2" | sed 's/.fst//');
reference2=$(echo "$2" | sed 's/.fasta//');
reference=$(echo "$reference2" | sed 's/.fst//');
refbase=$(basename "$reference");
mkdir $sample-results;
mv $input $sample-results;
echo "creating database...";
fp.py --length --header $sample-results/$input | sort -r -n > $sample-results/$sample-length.txt;
makeblastdb -in $sample-results/$input -dbtype nucl;
echo "running blastn query...";
blastn -query $reference.fasta -db $sample-results/$input -outfmt 5 -out $sample-results/$sample-to-$refbase.BLASTn.xml;
echo "running tblastx query...";
tblastx -query $reference.fasta -db $sample-results/$input -outfmt 5 -out $sample-results/$sample-to-$refbase.tBLASTx.xml;
grep "Hit_def" $sample-results/$sample-to-$refbase.tBLASTx.xml > $sample-results/$sample-list;
sed -i 's/  <Hit_def>//g' $sample-results/$sample-list;
sed -i 's/<\/Hit_def>//g' $sample-results/$sample-list;
echo "extracting contig sequences from fasta...";
fasta2tab $sample-results/$input | grep -f $sample-results/$sample-list | tab2fasta > $sample-results/results-$sample.fst;
echo "creating stats...";
mkdir $sample-results/stats;
echo $sample > $sample-results/stats/stats-$sample;
fp.py --length $sample-results/results-$sample.fst | wc -l >> $sample-results/stats/stats-$sample;
fp.py --length $sample-results/results-$sample.fst | cat | awk '{sum+=$1} END {print sum}' >> $sample-results/stats/stats-$sample;
perl -p -i -e 's/\n/\t/g' $sample-results/stats/stats-$sample;
mv $sample-results/$input ./;

echo "extracting longest contig as new reference...";
fp.py --longest $sample-results/results-$sample.fst > $sample-results/new_ref-$sample.fst;
echo "creating new database...";
makeblastdb -in $sample-results/results-$sample.fst -dbtype nucl;
echo "running blastn query against new reference...";
blastn -query $sample-results/new_ref-$sample.fst -db $sample-results/results-$sample.fst -outfmt 5 -out $sample-results/$sample-to-longest_fragment.BLASTn.xml;
echo "running tblastx query against new reference...";
tblastx -query $sample-results/new_ref-$sample.fst -db $sample-results/results-$sample.fst -outfmt 5 -out $sample-results/$sample-to-longest_fragment.tBLASTx.xml;
grep "Hit_def" $sample-results/$sample-to-longest_fragment.tBLASTx.xml > $sample-results/$sample-final-list;
sed -i 's/  <Hit_def>//g' $sample-results/$sample-final-list;
sed -i 's/<\/Hit_def>//g' $sample-results/$sample-final-list;
echo "extracting contig sequences from fasta...";
fasta2tab $sample-results/results-$sample.fst | grep -f $sample-results/$sample-final-list | tab2fasta > $sample-results/final-results-$sample.fst;
echo "**********finished**********";

