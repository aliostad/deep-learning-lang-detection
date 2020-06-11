
# MAY HAVE TO OPTIMIZE AMPLICON SIZE UNTIL GREG GETS BACK TO YOU, START AT 500

# INPUTFOLDER="/Groups/assembly/reads/"

# SAMPLESTART="lane8_RP1_GCCAAT_L008_R"
# ONE="1_"
# TWO="2_"
# SAMPLE[0]=001
# SAMPLE[1]=002
# SAMPLE[2]=003
# SAMPLE[3]=004
# SAMPLE[4]=005
# SAMPLE[5]=021
# SAMPLEEND=".fastq"

# OUTPUTFOLDER="/Groups/assembly/PRICEoutput/30pluscoverage33gut/"

# SEEDSTART="/Groups/assembly/PRICEseeds/30pluscoverage33gut/"
# SEEDEND=".fasta"

# for i in $SAMPLE
	# do
		# nohup /Groups/assembly/bin/PriceSource130506/PriceTI -fpp $INPUTFOLDER$SAMPLESTART$ONE$i$SAMPLEEND $INPUTFOLDER$SAMPLESTART$TWO$i$SAMPLEEND 500 95 -icf $SEEDSTART$i$SEEDEND 1 1 5 -nc 30 -dbmax 72 -mol 30 -tol 20 -mpi 80 -target 90 2 1 1 -o $OUTPUTFOLDER$i.fasta > $i.nohup.out 2>&1&
	# done

	
	
	
	
	
	
# BVAB
INPUTFOLDER="/Groups/assembly/BVABreads/"
SEEDFOLDER="/Groups/assembly/PRICEseeds/10to20coverageBVAB/"
OUTPUTFOLDER="/Groups/assembly/PRICEoutput/10to20coverageBVAB/"
SAMPLEMID="_L001_R"
ONE="1_"
TWO="2_"
SAMPLEEND="001.fastq"
for i in $(ls $SEEDFOLDER)
	do
		SAMPLE=${i/.fasta/}
		if [ $SAMPLE != "012A_S4" ]
		then
			echo $SAMPLE
			echo $i
			echo $INPUTFOLDER$SAMPLE$SAMPLEMID$ONE$SAMPLEEND
			echo $INPUTFOLDER$SAMPLE$SAMPLEMID$TWO$SAMPLEEND
			echo $SEEDFOLDER$i
			echo $OUTPUTFOLDER$SAMPLE/
			mkdir $OUTPUTFOLDER$SAMPLE/
			nohup /Groups/assembly/bin/PriceSource130506/PriceTI -fpp $INPUTFOLDER$SAMPLE$SAMPLEMID$ONE$SAMPLEEND $INPUTFOLDER$SAMPLE$SAMPLEMID$TWO$SAMPLEEND 500 95 -icf $SEEDFOLDER$i 1 1 5 -nc 30 -dbmax 72 -mol 30 -tol 20 -mpi 80 -target 90 2 1 1 -o $OUTPUTFOLDER$SAMPLE/$SAMPLE.PRICEoutput.fasta > $OUTPUTFOLDER$SAMPLE/$i.nohup.out 2>&1&
		fi
	done
	
	
	
	
# INPUTFOLDER="/Groups/assembly/reads/"
# SEEDFOLDER="/Groups/assembly/PRICEseeds/30pluscoverage33gut/"
# OUTPUTFOLDER="/Groups/assembly/PRICEoutput/30pluscoverage33gut/"
# SAMPLESTART="lane8_RP1_GCCAAT_L008_R"
# SAMPLEEND=".fastq"
# ONE="1_"
# TWO="2_"
# for i in $(ls $SEEDFOLDER)
	# do
		# SAMPLE=${i/.fasta/}
		# echo $SAMPLE
		# echo $i
		# echo $INPUTFOLDER$SAMPLE$SAMPLEMID$ONE$SAMPLEEND
		# echo $INPUTFOLDER$SAMPLE$SAMPLEMID$TWO$SAMPLEEND
		# echo $SEEDFOLDER$i
		# echo $OUTPUTFOLDER$SAMPLE/
		# mkdir $OUTPUTFOLDER$SAMPLE
		# nohup /Groups/assembly/bin/PriceSource130506/PriceTI -fpp $INPUTFOLDER$SAMPLESTART$ONE$SAMPLE$SAMPLEEND $INPUTFOLDER$SAMPLESTART$TWO$SAMPLE$SAMPLEEND 500 95 -icf $SEEDFOLDER$i 1 1 5 -nc 30 -dbmax 72 -mol 30 -tol 20 -mpi 80 -target 90 2 1 1 -o $OUTPUTFOLDER$SAMPLE/$SAMPLE.PRICEoutput.fasta > $i.nohup.out 2>&1&
	# done




	
	
	
	
	
# /Groups/assembly/bin/PriceSource130506/PriceTI -fpp /Groups/assembly/reads/lane8_RP1_GCCAAT_L008_R1_001.fastq /Groups/assembly/reads/lane8_RP1_GCCAAT_L008_R2_001.fastq 500 95 -icf sangerReads.fasta 1 1 5 -nc 30 -dbmax 72 -mol 30 -tol 20 -mpi 80 -target 90 2 1 1 -o practice.


# nohup ./PriceTI -fpp /Groups/assembly/reads/lane8_RP1_GCCAAT_L008_R1_001.fastq /Groups/assembly/reads/lane8_RP1_GCCAAT_L008_R2_001.fastq 300 95 -icf sangerReads.fasta 1 1 5 -nc 30 -dbmax 72 -mol 30 -tol 20 -mpi 80 -target 90 2 1 1 -o practice. 2> "PRICEOutputSummary.txt" &