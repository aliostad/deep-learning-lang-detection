#!/bin/bash
bwaDir=/usr/bin
samtoolsDir=/usr/bin
freebayesDir=/usr/local/bin
pindelDir=/usr/local/bin
picardDir=/usr/bin


exec &> $(date +%y%m%d).RunLog.StdOp.Err.txt; #Redirect the stdout and stderror to a text file
echo "Starting Run ==" `date +%d/%m/%Y\ %H:%M:%S`
echo $bwaDir $samtoolsDir 
fil=$1 #file containing fastq file locations (SampleName<tab>R1.fq<tab>R2.fq)
fastaFil=$2 # # location of bwa indexed genome files
bedFil=$3
#picardBedFile=$4 ##Bed file with extra column (Strand) for picard
while read -r -a inputSamples
do
	echo "begin loop"
	currwd=`pwd`
	if [ "${#inputSamples[@]}" == 3 ]; then	
		echo "array len 3"
		sampleName=${inputSamples[0]}; #Name of the sample 
		readOne=${inputSamples[1]}; # Read file one
		readTwo=${inputSamples[2]}; # Read file two
		exeCmd="mkdir $sampleName";
		echo "Starting " $sampleName "Run ==" `date +%d/%m/%Y\ %H:%M:%S`
		echo exeCmd
		eval $exeCmd
		
		#Run once once
		exeCmd="$bwaDir/bwa index $fastaFil"
		#echo $exeCmd
		#eval $exeCmd

		echo $sampleName $readOne $readTwo;
		exeCmd="$bwaDir/bwa mem -t 4 $fastaFil  $readOne $readTwo | samtools view -Sh -F 4 -b - | samtools sort - $sampleName/$sampleName.bwaln.sorted 2> $sampleName/${sampleName}.log";
		echo $exeCmd
		eval $exeCmd
		
		exeCmd="$samtoolsDir/samtools index $sampleName/$sampleName.bwaln.sorted.bam";
		echo $exeCmd
		eval $exeCmd
		
		exeCmd="$samtoolsDir/samtools calmd -Abr $sampleName/$sampleName.bwaln.sorted.bam $fastaFil > $sampleName/$sampleName.bwaln.sorted.baq.bam";
		echo $exeCmd
		eval $exeCmd
		
		exeCmd="$samtoolsDir/samtools index $sampleName/$sampleName.bwaln.sorted.baq.bam";
		echo $exeCmd
		eval $exeCmd

		#Picard Tool for Marking Duplicates
		exeCmd="$picardDir/picard-tools MarkDuplicates I=$sampleName/$sampleName.bwaln.sorted.baq.bam O=$sampleName/$sampleName.bwaln.sorted.baq.rdp.bam M=$sampleName/$sampleName.bwaln.sorted.baq.markduplicates.stats.txt REMOVE_DUPLICATES=true VALIDATION_STRINGENCY=SILENT";
		echo $exeCmd
		eval $exeCmd

		#Picard Tool for Alignment Metrices
		exeCmd="$picardDir/picard-tools CollectAlignmentSummaryMetrics R=$fastaFil I=$sampleName/$sampleName.bwaln.sorted.baq.rdp.bam O=$sampleName/$sampleName.bwaln.sorted.baq.rdp.picard.alignment.metrices.txt VALIDATION_STRINGENCY=SILENT";
		echo $exeCmd
		eval $exeCmd
		
		#Create the bed file for Picard
		exeCmd="$samtoolsDir/samtools view -H $sampleName/$sampleName.bwaln.sorted.baq.rdp.bam | tail -n +2 | head -n -1 > $sampleName/$sampleName.bwaln.sorted.baq.rdp.header.txt"
		echo $exeCmd
		eval $exeCmd
		
		#Add the strand column in the bed file for picard
		exeCmd="awk '{FS="\t"; OFS="\t";print $1,$2,$3,"+",$4;}' $bedFil > $sampleName/$sampleName.bwaln.sorted.baq.rdp.picard.bed.txt"
		echo $exeCmd
		eval $exeCmd

		#Create the bed file for Picard
		exeCmd="cat $sampleName/$sampleName.bwaln.sorted.baq.rdp.header.txt $sampleName/$sampleName.bwaln.sorted.baq.rdp.picard.bed.txt > $sampleName/$sampleName.bwaln.sorted.baq.rdp.picard.target.txt"
		echo $exeCmd
		eval $exeCmd

		#Picard Tool for Hs-Metrices
		exeCmd="$picardDir/picard-tools CalculateHsMetrics I=$sampleName/$sampleName.bwaln.sorted.baq.rdp.bam O=$sampleName/$sampleName.bwaln.sorted.baq.rdp.picard.hs-metrics.txt VALIDATION_STRINGENCY=SILENT BAIT_INTERVALS=$sampleName/$sampleName.bwaln.sorted.baq.rdp.picard.target.txt TARGET_INTERVALS=$sampleName/$sampleName.bwaln.sorted.baq.rdp.picard.target.txt R=$fastaFil PER_TARGET_COVERAGE=$sampleName/$sampleName.bwaln.sorted.baq.rdp.picard.hs-metrics-pertarget-coverage.txt";
		echo $exeCmd
		eval $exeCmd


		#SNP call using the *.baq.bam files
		exeCmd="$freebayesDir/freebayes --min-base-quality 20 --min-alternate-fraction 0.01 --ploidy 1 --fasta-reference $fastaFil --targets $bedFil $sampleName/$sampleName.bwaln.sorted.baq.rdp.bam > $sampleName/$sampleName.bwaln.sorted.baq.rdp.fb.targets.vcf"
		echo $exeCmd
		eval $exeCmd
		
		#exeCmd="vcftools --vcf $sampleName/$sampleName.bwaln.sorted.baq.fb.vcf --bed $bedFil --out $sampleName/$sampleName.bwaln.sorted.baq.fb.sub.vcf --recode --keep-INFO-all"
		#echo $exeCmd
		#eval $exeCmd

		#Filtering the variants		
		exeCmd="cat $sampleName/$sampleName.bwaln.sorted.baq.rdp.fb.targets.vcf | vcf-annotate -f +/-a/c=3,10/q=3/d=20/-D > $sampleName/$sampleName.bwaln.sorted.baq.rdp.fb.targets.filter.vcf"
		echo $exeCmd
		eval $exeCmd
		
		exeCmd="java -Xmx4g -jar /usr/bin/snpEff/snpEff.jar hg19 $sampleName/$sampleName.bwaln.sorted.baq.rdp.fb.targets.filter.vcf > $sampleName/$sampleName.bwaln.sorted.baq.rdp.fb.targets.filter.annot.vcf"
		echo $exeCmd
		eval $exeCmd
		
		exeCmd="vcf2tsv $sampleName/$sampleName.bwaln.sorted.baq.rdp.fb.targets.filter.annot.vcf > $sampleName/$sampleName/.bwaln.sorted.baq.rdp.fb.targets.filter.annot.tsv"
		echo $exeCmd
		eval $exeCmd
		
		echo "$sampleName/$sampleName.bwaln.sorted.baq.rdp.bam	250	$sampleName" > $sampleName/config.txt
		exeCmd="$pindelDir/pindel -T 4 -x 2 -M 5 -L $sampleName/$sampleName.pindel.log  -f /data/genomes/human_g1k_v37.fasta -i $sampleName/config.txt -c ALL -o $sampleName/$sampleName.pindel &"
		echo $exeCmd
		eval $exeCmd
		echo "Ending " $sampleName "Run ==" `date +%d/%m/%Y\ %H:%M:%S`

		fi
done < "$1"
echo "Ending Run ==" `date +%d/%m/%Y\ %H:%M:%S`
