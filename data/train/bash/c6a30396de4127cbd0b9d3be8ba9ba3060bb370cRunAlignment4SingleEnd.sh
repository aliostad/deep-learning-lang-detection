#! /bin/bash

#sh ~/Script_bash/RunAlignment4SingleEnd.sh Sample_9.txt  
while read line; do

#f1=`echo "$line" | awk -F"\t" '{print $1}'`
#f2=`echo "$line" | awk -F"\t" '{print $2}'`

f=`echo "$line"`

echo "$f"
sample_name=`echo "$f" | awk -F"." '{print $1}'`

echo "$sample_name"

cat > ~/Script_bash/Run_"$sample_name"_tophat.sh <<EOF
tophat -G ~/genes.gtf -p 4 -o "$sample_name"_tophat_out ~/mm10_index_bt2/genome "$f"
mv "$sample_name"_tophat_out/accepted_hits.bam "$sample_name".bam
EOF

bsub -P Bioinformatics4count < ~/Script_bash/Run_"$sample_name"_tophat.sh

done < $1