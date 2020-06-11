# sh haplohseq2Expands.sh [proj dir]

PROJ=$1
cd $PROJ/haplohseq
for SAMPLE in `ls *.events.dat | cut -d. -f1 ` ; do
    COUNT=`cat $SAMPLE.events.dat | wc -l`
    
    if [ "$COUNT" -gt "1" ]; then
        echo "$SAMPLE has $COUNT events"
        EVENT=$SAMPLE.events.bed
        SNV=$SAMPLE.posterior.bed
        LOH=$SAMPLE.haplohseq.expands_snv
        
        # remove header
        sed '1d' $SAMPLE.events.dat > $EVENT
        
        # format posterior file to look like expands snv input 
        sed '1d' $SAMPLE.posterior.dat | awk '{FS=OFS="\t"; print $1, $2-1, $2, 1-$9, 1}' > $SNV
        
        # intersect
        intersectBed -a $SNV -b $EVENT  -wa | cut -f1,3- | sed 's/chr//g' > ../expands/$LOH
    else
        echo "$SAMPLE has no events."
    fi
done

# Combined snv loh
cd $PROJ/expands

for SNV in `ls *mutect*snv`; do
    SAMPLE=`echo $SNV | cut -d- -f2`
    echo $SAMPLE
    LOH=`ls *haplohseq* | grep $SAMPLE`
    COMBINED=$SAMPLE.combined
    if [ "$LOH" == "" ]; then 
        cp $SNV $COMBINED
    else
        head -1 $SNV > $COMBINED && (sed '1d' $SNV; cat $SAMPLE*haploh*) | sort -k1,1n -k2,2n >> $COMBINED
    fi
done
