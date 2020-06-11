DIR=/home/rgarcia/MCAC/sam
ADDORREPLACEREADGROUPS=/home/rgarcia/downloads/picard-tools-1.121/AddOrReplaceReadGroups.jar

for SAMPLE in $(seq -f "%02g" 17 26)
do
    samtools sort -o $DIR/mau29/S${SAMPLE}.bam \
	     -O bam -T $DIR -@ 30 -m 8G $DIR/mau29/S${SAMPLE}.sam



    BAM=$DIR/mau29/S${SAMPLE}.bam
    BAMOUT=$DIR/mau29/S${SAMPLE}_rg.bam
    java -jar $ADDORREPLACEREADGROUPS \
                 I=$BAM \
                 LB='mcac' \
                 PL='ion' \
                 PU='nil' \
                 SM=$SAMPLE \
                 O=$BAMOUT
    
done

