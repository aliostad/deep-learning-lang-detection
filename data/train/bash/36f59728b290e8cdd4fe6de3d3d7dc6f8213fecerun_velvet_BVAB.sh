S[0]="006A_S1"
S[1]="009A_S2"
S[2]="010A_S3"
S[3]="012A_S4"

SOURCESTART="/Groups/assembly/BVAB1_PROJECT/Bowtie2MappedReadsToJeansDB2/"
SOURCEMID=".unmapped."
SOURCEEND=".fastq"
ONE="1"
TWO="2"
OUTPUTFOLDER="/Groups/assembly/BVAB1_PROJECT/SubtractiveEnrichmentVelvetOutput/"


for sample in ${S[@]}; do
	echo $sample
	echo $OUTPUTFOLDER$sample
	echo $OUTPUTFOLDER$sample.velvetg.out
	echo $SOURCESTART$sample/$sample.nonhuman.1.fastq
	mkdir $OUTPUTFOLDER$sample/
	
	#nohup /Groups/assembly/bin/velvet_1.2.10/velveth $OUTPUTFOLDER$sample/ 31 -fastq -shortPaired -separate $SOURCESTART$sample/$sample.nonhuman.1.fastq $SOURCESTART$sample/$sample.nonhuman.2.fastq > $OUTPUTFOLDER$sample.out 2>&1&
	#nohup /Groups/assembly/bin/velvet_1.2.10/velvetg $OUTPUTFOLDER$sample/ > $OUTPUTFOLDER$sample.velvetg.out 2>&1&
	
	#* * * * * * * * * * * * * * * * * * * * * * * * * * * * *#
	#FOR TRIMMED READS
	#* * * * * * * * * * * * * * * * * * * * * * * * * * * * *#
	#nohup /Groups/assembly/bin/velvet_1.2.10/velveth $OUTPUTFOLDER$sample/ 31 -fastq -shortPaired -separate $SOURCESTART$sample/$sample$SOURCEMID$ONE$SOURCEEND $SOURCESTART$sample/$sample$SOURCEMID$TWO$SOURCEEND  > $OUTPUTFOLDER$sample.out 2>&1&
	#nohup /Groups/assembly/bin/velvet_1.2.10/velvetg $OUTPUTFOLDER$sample/ > $OUTPUTFOLDER$sample.velvetg.out 2>&1&
	
	#* * * * * * * * * * * * * * * * * * * * * * * * * * * * *#
	#FOR COMBINED AND TRIMMED READS
	#* * * * * * * * * * * * * * * * * * * * * * * * * * * * *#
	#nohup /Groups/assembly/bin/velvet_1.2.10/velveth $OUTPUTFOLDER$sample/ 31 -fastq -shortPaired -separate $SOURCESTART$sample/$sample$SOURCEMID$ONE$SOURCEEND $SOURCESTART$sample/$sample$SOURCEMID$TWO$SOURCEEND  > $OUTPUTFOLDER$sample.out 2>&1&
	#nohup /Groups/assembly/bin/velvet_1.2.10/velvetg $OUTPUTFOLDER$sample/ > $OUTPUTFOLDER$sample.velvetg.out 2>&1&

	#* * * * * * * * * * * * * * * * * * * * * * * * * * * * *#
	#FOR READS WITH KNOWN GENES SUBTRACTED
	#* * * * * * * * * * * * * * * * * * * * * * * * * * * * *#
	#nohup /Groups/assembly/bin/velvet_1.2.10/velveth $OUTPUTFOLDER$sample/ 31 -fastq -shortPaired -separate $SOURCESTART$sample/$sample$SOURCEMID$ONE$SOURCEEND $SOURCESTART$sample/$sample$SOURCEMID$TWO$SOURCEEND > $OUTPUTFOLDER$sample.out 2>&1&
	nohup /Groups/assembly/bin/velvet_1.2.10/velvetg $OUTPUTFOLDER$sample/ > $OUTPUTFOLDER$sample.velvetg.out 2>&1&
done

#just run this script and only use either velveth or velvetg, and comment out the other one

# nohup /Groups/assembly/bin/velvet_1.2.10/velveth  /Groups/assembly/BVAB1_PROJECT/SubtractiveEnrichmentVelvetOutput/pooled/ 31 -fastq -shortPaired -separate /Groups/assembly/BVAB1_PROJECT/Bowtie2MappedReadsToJeansDB2/pooled/pooled.unmapped.1.fastq /Groups/assembly/BVAB1_PROJECT/Bowtie2MappedReadsToJeansDB2/pooled/pooled.unmapped.2.fastq > /Groups/assembly/BVAB1_PROJECT/SubtractiveEnrichmentVelvetOutput/pooled.nohup.out 2>&1&
