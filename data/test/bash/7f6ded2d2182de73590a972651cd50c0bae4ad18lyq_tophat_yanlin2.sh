export LD_LIBRARY_PATH=/psc/program/install/boost-1.55/lib:$LD_LIBRARY_PATH
wd=/psc/program/install/tophat-2.0.10/bin
wd1=/psc/bioinformatics/lyq/test
wd2=/psc/home/liyanqiang/Arab
genome=$wd2/arab10
GFF=$wd2/TAIR10.gtf
sample=/psc/home/liyanqiang/lyq/yanlin/L002/${SGE_TASK_ID}
# Loop for samples
#for sample in yzb-11  
 #yzb-17 yzb-18 yzb-19 
# yzb-17 yzb-18 yzb-19 
#for sample in  NHR01768 NHR01769                                                                             

    # print  timestamp 
    echo "$sample begin at "  
    date
 
    $wd/tophat -p 30    -G $GFF  -o $sample $genome  ${sample}_1.fq ${sample}_2.fq  

    samtools sort -n $sample/accepted_hits.bam  $sample/accepted_hits.sorted
   # samtools   view  -h    $sample/accepted_hitsd.bam > $sample/accepted_hits.sorted.sam 
    echo "ID	Sample_${SGE_TASK_ID}" >${sample}_out
	htseq-count -f bam   -m union -s no -q $sample/accepted_hits.sorted.bam $GFF >>${sample}_out
    'rm' $sample/accepted_hits.sorted.bam
    
#	samtools view -c  $sample/unmapped.bam  >>$sample.outcome.txt 
#	samtools view   $sample/accepted_hits.bam |grep -ce "\bNH:i:1\b"  >>$sample.outcome.txt
    # print timestamp
    echo "$sample finished at "
    date


# Loop for samples
