
	
# BVAB
S[0]="006A_S1"
S[1]="009A_S2"
S[2]="010A_S3"
S[3]="012A_S4"
INPUTFOLDER="/Groups/assembly/BVABreads/"
OUTPUTFOLDER="/Groups/assembly/Bowtie2Output/"
SAMPLEMID="_L001_R"
ONE="1_"
TWO="2_"
SAMPLEEND="001.fastq"
for i in ${S[@]}
	do
		SAMPLE=${i/.fasta/}
		echo $SAMPLE
		echo $i
		echo $INPUTFOLDER$SAMPLE$SAMPLEMID$ONE$SAMPLEEND
		echo $INPUTFOLDER$SAMPLE$SAMPLEMID$TWO$SAMPLEEND
		echo $SEEDFOLDER$i
		echo $OUTPUTFOLDER$SAMPLE/
		echo $OUTPUTFOLDER$SAMPLE/$SAMPLE/nonhuman/
		mkdir $OUTPUTFOLDER$SAMPLE/
		# -N number of mismatches
		/Groups/twntyfr/bin/bowtie2-2.1.0/bowtie2 --very-sensitive -N 1 -x /Groups/twntyfr/index/hg19 -1 $INPUTFOLDER$i$SAMPLEMID$ONE$SAMPLEEND -2 $INPUTFOLDER$i$SAMPLEMID$TWO$SAMPLEEND -S $OUTPUTFOLDER$SAMPLE/$SAMPLE.human.sam --un-conc $OUTPUTFOLDER$SAMPLE/$SAMPLE.nonhuman.fastq -p 8
	done
	
	
	
	