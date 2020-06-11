#!/bin/bash

#### $samplefile has a sample file with server, name, path
CWD=$(pwd)

cd $(dirname "$1")
samplefile=$(pwd)/$(basename "$1")
cd $CWD

while read line
do
	arr=($line);
	sample=${arr[1]}
	location=${arr[2]}
	if [ -f ${arr[2]} ];
	then
		echo "processing $sample..."
		samtools view -f 12 -F 256 $location | head -n 10000000 | samtools view -S -u - > $sample.small.bam

		$REPOS/phylogenomics/converting/bam_to_fastq.sh $sample.small.bam $sample
		rm $sample.small.bam
		$REPOS/phylogenomics/converting/unpair_seqs.pl $sample.fastq $sample
		rm $sample.fastq

		ref=$2
		echo "looking at $ref"
		filename=$(basename "$ref")
		refname="${filename%.*}"

		if [ -f $refname.index.1.bt2 ]
		then
			echo "using $refname as index"
		else
			bowtie2-build $ref $refname.index 2>/dev/null
		fi
		mkdir $refname
		cd $CWD/$refname
		pwd
		rm results.txt

		if [ -f $sample.vcf ]
		then
			echo "$sample.vcf already exists"
		else
			echo "using $ref as reference"

			bowtie2 -p 8 --no-unal --no-discordant --no-mixed --no-contain -x ../$refname.index -1 ../$sample.1.fastq -2 ../$sample.2.fastq -S $sample.sam
			samtools view -S -b -u $sample.sam | samtools view -F 4 -b - > $sample.reduced.bam
			rm $sample.sam
			mv $sample.reduced.bam $sample.bam
			samtools sort $sample.bam $sample.sorted
			rm $sample.bam
			samtools mpileup -B -C50 -I -f $ref -u $sample.sorted.bam > $sample.bcf
			bcftools view -c $sample.bcf > $sample.vcf
			rm $sample.bcf $sample.sorted.bam
		fi
		echo "$sample" >> results.txt
		grep -c -E "PL\s+.+,0," $sample.vcf >> results.txt
		cd $CWD
		rm $sample.*.fastq
	fi
done < $samplefile
