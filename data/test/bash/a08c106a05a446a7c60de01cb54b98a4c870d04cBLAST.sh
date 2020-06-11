
	
# BVAB
# S[0]="006A_S1"
# S[1]="009A_S2"
# S[2]="010A_S3"
# S[3]="012A_S4"
S[0]="006A_S1"
S[1]="009A_S2"
INPUTFOLDER="/Groups/assembly/BLASTinput/lengthover100protcoverageover10/"
OUTPUTFOLDER="/Groups/assembly/BLASToutput/filtered_human_removed/"
#OUTPUTFOLDER="/Groups/assembly/BLASToutput/BLASTSEEDoutput/"
SAMPLEEND="_MetaGeneOutput_filtered.faa"
OUTPUTEND="_BLASToutput.xml"
for i in ${S[@]}
	do
		SAMPLE=${i/.fasta/}
		echo $SAMPLE
		echo $i
		echo $INPUTFOLDER$SAMPLE/$SAMPLE$SAMPLEEND
		echo $OUTPUTFOLDER$SAMPLE/$SAMPLE$OUTPUTEND
		echo $OUTPUTFOLDER$SAMPLE.blast.nohup.out
		echo $OUTPUTFOLDER$SAMPLE/
		mkdir $OUTPUTFOLDER$SAMPLE/
		nohup blastp -db /Groups/assembly/nr/nr -query $INPUTFOLDER$SAMPLE/$SAMPLE$SAMPLEEND -out $OUTPUTFOLDER$SAMPLE/$SAMPLE$OUTPUTEND -outfmt 5 -evalue 1e-3 -num_alignments 10 -num_threads 4 > $OUTPUTFOLDER$SAMPLE.blast.nohup.out 2>&1&
		#nohup blastp -db /Groups/twntyfr/SEED_subsystems/BLAST/db_fastas.complex.faa -query $INPUTFOLDER$SAMPLE/$SAMPLE$SAMPLEEND -out $OUTPUTFOLDER$SAMPLE/$SAMPLE$OUTPUTEND -outfmt 6 -evalue 1e-3 -num_alignments 10 -num_threads 4 > $OUTPUTFOLDER$SAMPLE.blast.nohup.out 2>&1&
	done
