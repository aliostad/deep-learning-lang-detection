#!/bin/bash

#### $samplefile has a sample file with name, path to reads in fasta format.
samplefile=$1

#### for each de novo sample:
reffile="$REPOS/reproducibility/plastome_assembly/trichocarpa_cp.gb
if [ -e $2 ];
then
	reffile=$(pwd)/$(basename "$2")
fi
echo "using $reffile as reference"

CWD=$(pwd)
while read line
do
	arr=($line);
	sample=${arr[0]}
	location=${arr[2]}
	comment=$(echo $line | grep -c "#" -)
	if [ $comment -ne 0 ];
	then
		echo "skipping $sample"
		continue;
	fi
	echo "processing $sample..."
	mkdir $sample
	cd $sample

	#### use velvet
	echo "  assembling contigs with Velvet"
	velveth $sample 31 -shortPaired -fasta -interleaved $sample.fasta
	velvetg $sample -cov_cutoff 20 -ins_length 400 -min_contig_lgth 300
#
	#### rename contigs from NODE_2_length_25848_cov_191.293564 to $sample_
	sed s/NODE/$sample/ < $sample/contigs.fa | sed s/_length.*// > $sample.contigs.fasta
#
	#### make draft plastome
	echo "  assembling draft plastome from contigs"
	perl $REPOS/phylogenomics/plastome/contigs_to_cp.pl -ref $reffile -contig $sample.contigs.fasta -out $sample.plastome -join
#
	#### aTRAM libs
 	echo "  making aTRAM db"
 	perl $REPOS/aTRAM/format_sra.pl -in $sample.fasta -out aTRAMdbs/$sample -num 10

	echo "filling in $sample..."
	echo -e ">$sample\n" > $sample.plastome.final.fasta
	gawk '$0 !~ />/ { print $0; }' $sample.plastome.draft.fasta >> $sample.plastome.final.fasta
#
	#### find sections of ambiguity in the draft plastome:
	grep -o -E ".{200}[Nn]+.{200}" $sample.plastome.final.fasta > $sample.to_atram.txt
#
	rm $sample.targets.txt
	count=1
	while read seq
	do
		echo ">$sample.$count" > $sample.$count.fasta
		echo "$seq" >> $sample.$count.fasta
		echo -e "$sample.$count\t$sample.$count.fasta" >> $sample.targets.txt
		count=$(($count+1))
	done < $sample.to_atram.txt
	echo -e "$sample\t$CWD/aTRAMdbs/$sample.atram" > $sample.samples.txt
#
	#### aTRAM those ambiguous sections
	echo "  aTRAM ambiguous sections"
	perl $REPOS/aTRAM/Pipelines/BasicPipeline.pl -samples $sample.samples.txt -target $sample.targets.txt -iter 10 -out $sample.atram
#
	#### Now, take the best seq from each one and align it to the draft:
	head -n 1 $sample.plastome.final.fasta > $sample.plastome.0.fasta
	tail -n +2 $sample.plastome.final.fasta | sed s/[Nn\n]/-/g >> $sample.plastome.0.fasta
	for ((i=1;i<10;i++))
	do
		#### if there were atram results, align and consensus:
		if [ -f $sample.atram/$sample/$sample.$i.best.fasta ]
		then
			echo "aligning atram results $i"
			j=$(($i-1))
			echo ">$sample.plastome.$j" > $sample.plastome.$i.fasta
			tail -n +2 $sample.plastome.$j.fasta | sed s/[Nn]/-/g >> $sample.plastome.$i.fasta
			head -n 1 $sample.atram/$sample/$sample.$i.best.fasta >> $sample.plastome.$i.fasta
			head -n 2 $sample.atram/$sample/$sample.$i.best.fasta | tail -n 1 | sed s/[Nn]/-/g >> $sample.plastome.$i.fasta
#
			#### align with large gap-opening penalty: gaps already exist, we don't need to add more.
			mafft --retree 2 --maxiterate 0 --op 10 $sample.plastome.$i.fasta > $sample.plastome.$i.aln.fasta 2>/dev/null
			perl $REPOS/phylogenomics/filtering/consensus.pl $sample.plastome.$i.aln.fasta > $sample.plastome.$i.fasta
			#### final sequence is the last one:
			#### remove gaps in sequence:
			head -n 1 $sample.plastome.$i.fasta > $sample.plastome.final.fasta
			tail -n +2 $sample.plastome.$i.fasta | sed s/-//g >> $sample.plastome.final.fasta
		fi
	done
#
	#### clean draft plastome
	perl $REPOS/phylogenomics/plastome/clean_cp.pl -ref $reffile -contig $sample.plastome.final.fasta -out $sample.plastome
	cd $CWD
done < $samplefile
