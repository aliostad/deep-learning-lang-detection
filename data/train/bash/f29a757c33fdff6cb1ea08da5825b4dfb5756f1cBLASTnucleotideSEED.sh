
	
# BVAB
S[0]="006A_S1"
S[1]="009A_S2"
S[2]="010A_S3"
S[3]="012A_S4"
INPUTFOLDER="/Groups/assembly/BVAB1_PROJECT/BLASTinput/contigslengthover300coverageover5/"
OUTPUTFOLDER="/Groups/assembly/BVAB1_PROJECT/BLASToutput/contigslengthover300coverageover5_with_slen/"
SAMPLEEND="_velvet_contigs_filtered.fa"
OUTPUTEND="_BLASTXoutput.tsv"
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
		nohup blastx -db /Groups/twntyfr/SEED_subsystems/db_fastas.complex_plusold.faa -query $INPUTFOLDER$SAMPLE/$SAMPLE$SAMPLEEND -out $OUTPUTFOLDER$SAMPLE/$SAMPLE$OUTPUTEND -outfmt "6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore slen" -evalue 1e-3 -num_alignments 10 -num_threads 3 > $OUTPUTFOLDER$SAMPLE.blast.nohup.out 2>&1&
	done
