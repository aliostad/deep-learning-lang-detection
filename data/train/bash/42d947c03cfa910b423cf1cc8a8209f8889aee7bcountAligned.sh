#!/bin/bash
export LC_ALL='C'
samtools view -f 0x40 $1/accepted_hits.bam | awk '{print $1}' | sort -b | uniq -c | awk -v sample="$1" '{if($1==1) sum+=1} END {print sample,"aligned.first",sum,NR}' >> $2
samtools view -f 0x80 $1/accepted_hits.bam | awk '{print $1}' | sort -b | uniq -c | awk -v sample="$1" '{if($1==1) sum+=1} END {print sample,"aligned.second",sum,NR}' >> $2
samtools view -f 0x40 $1/accepted_hits.bam | awk '{if($3~"ERCC") print $1}' | sort -b | uniq -c | awk -v sample="$1" '{if($1==1) sum+=1} END {print sample,"controls.first",sum,NR}' >> $2 
samtools view -f 0x80 $1/accepted_hits.bam | awk '{if($3~"ERCC") print $1}' | sort -b | uniq -c | awk -v sample="$1" '{if($1==1) sum+=1} END {print sample,"controls.second",sum,NR}' >> $2 

