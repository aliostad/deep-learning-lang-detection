#!/bin/bash
#load path from .bashrc
#source /home/arun/.bashrc
# this file will generate a report of viruses from sample $sample

set -u

### Variables ###
sample='LR-103-trimmed-unmapped'
reads='../data/trimmed-unmapped/'$sample'.fa'
refseq=(`find ../data/refseq/*.fasta -type f`)
nsplit=16
blast_threads=2

## 1. Assemble the trimmed reads
echo '##########################'
echo '### Assembling '$sample' ###'
echo '##########################'
idba_ud -r $reads -o ../results/$sample/contigs/ --mink 29 --maxk 49 --step 2

## 2. Blast the resulting contigs
echo '################################'
echo '### Running BLAST on '$sample' ###'
echo '################################'
cp ../results/$sample/contigs/contig.fa ../temp/$sample/
pyfasta split -n $nsplit ../temp/$sample/contig.fa
contigs=(`find ../temp/$sample/contig.??.fa -type f`)
for file in ${contigs[@]}
do
    filename=${file##*/}
    time blastx -db nr -query $file -evalue 10 -matrix 'BLOSUM62' -word_size 3 -gapopen 11 -gapextend 1 -max_target_seqs 3 -outfmt "10 qseqid qlen sseqid evalue bitscore sskingdoms stitle sblastnames salltitles scomnames sscblyinames" -out ../results/$sample/blast/$filename-blast.csv -num_threads $blast_threads -seg "yes" &
done
wait
cat ../results/$sample/blast/contig.??.fa-blast.csv > ../results/$sample/blast/$sample-blast.csv

## 3. Generate a report from the contigs
echo '#####################################'
echo '### Generating report for '$sample' ###'
echo '#####################################'
## 3a1. remove unneeded contigs:
echo '### Removing excess contigs for '$sample' ###'
grep -f ../data/virus-names/$sample.txt ../results/$sample/blast/$sample-blast.csv > ../results/$sample/blast/$sample-blast.clean.csv
## 3a2. get counts for each virus:
echo '### Counting contigs for each virus for '$sample' ###'
python countContigs.py ../results/$sample/blast/$sample-blast.clean.csv 

## 3b1. get list of contigs from clean contigs:
echo '### Getting list of contigs for each virus for '$sample' ###'
cut -f 1 -d ',' ../results/$sample/blast/$sample-blast.clean.csv | sort | uniq | grep -A1 ../results/$sample/contigs/contig.fa -f - > ../results/$sample/contigs/virus_contig.fa
## 3b2. map all contigs to each reference genome
for ref in "${refseq[@]}"
do
	if [ ! -f $ref.bwt ]; then
    	bwa index -a bwtsw $ref
	fi
done
map () {
	for ref in "${refseq[@]}"
	do
		refstr=${ref##*/}		
		echo "##### MAPPING CONTIGS TO $ref"
		bwa bwasw $ref ../results/$sample/contigs/virus_contig.fa > ../temp/$1/alignment.sam
		samtools view -bS -F 4 ../temp/$1/alignment.sam > ../temp/$1/mapped.alignment.bam
		samtools sort ../temp/$1/mapped.alignment.bam ../temp/$1/mapped.sorted.alignment
		samtools index ../temp/$1/mapped.sorted.alignment.bam
		genomeCoverageBed -ibam ../temp/$1/mapped.sorted.alignment.bam -g $ref -d -max 1 > ../temp/$1/$refstr.$sample.coverageHist.txt
		awk 'BEGIN {count=0} $3 != 0 {count += 1} END {print (count/NR)*100}' ../temp/$1/$refstr.$sample.coverageHist.txt > ../results/$sample/coverage/$refstr.$sample.coverage.txt
	done
}
echo '### Calculating coverage for each virus in '$sample' ###'
map $sample

## 3c1. get names of contigs for each virus
echo '### Retrieving read numbers '$sample' ###'
python countReads.py ../results/$sample/blast/$sample-blast.clean.csv $sample

## 3c2. match contig names with contigs in contig file
viruscontigs=(`find ../temp/$sample/contigs*.txt -type f`)
for virus in "${viruscontigs[@]}"
do
	refstr=${virus##*/}
	grep -f $virus ../results/$sample/contigs/contig.fa | cut -d ' ' -f 3 | cut -d '_' -f 3 | awk '{sum += $1} END {print sum}' > ../results/$sample/reads/$refstr.$sample.reads.txt
done

echo '### Done! ###'
