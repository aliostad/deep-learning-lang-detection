#!/bin/bash
#################################
# This is a program for iCLIP peak calling using CIMS/CITS (Cross link Induced Truncation Sites)
# The input is the mapped reads from NovoAlign
# Written by Zhi John Lu @ Nov. 29, 2014
# Ref.: Moore, M. J. et al. Mapping Argonaute and conventional RNA-binding protein interactions with RNA at single-nucleotide resolution using HITS-CLIP and CIMS analysis. Nature protocols (2014).
# Link: http://zhanglab.c2b2.columbia.edu/index.php/CIMS_Documentation#CITS_analysis
#################################
pval=$1 
file_list=$2
sourcedir=$3
#sourcedir=/data3/users3/yangyucheng/projects/CLIPdb2.0/database/mouse/2_mapping/iCLIP
#sourcedir=/data3/users3/yangyucheng/projects/CLIPdb2.0/database/human/2_mapping/iCLIP
CIMS=/data/apps/CIMS
#generate a list of mapped reads (from novoalign) for iCLIP
#\ls data3/users3/yangyucheng/projects/CLIPdb2.0/database/mouse/2_mapping/iCLIP/*/*.novoalign  |cut -d "/"  -f 11-12 | sed 's/.novoalign//' 

if [ $# -eq 0 ]
  then
    echo "Please type in:"
	echo "		./iCLIP_CITS.qsub.sh 0.001 example.list novoalign_result_dir"
	exit 1
fi


########################
#run peak calling on them
########################
for sample in `cat $file_list`;do  
	IFS='\/' read -a tmp <<< "$sample"
	sample=${tmp[1]}
	dir=$sourcedir/${tmp[0]}
	
	cat <<EOF > $sample.$pval.qsub
#$ -S /bin/bash 
#$ -cwd 
#$ -j y 
#$ -N S${sample: -3}.$pval.job 
#$ -pe make 1

	export PERL5LIB=\$PERL5LIB:/home/yangyucheng/apps/czplib.v1.0.4:/home/yangyucheng/lib:/home/yangyucheng/perl5/lib/perl5/x86_64-linux-thread-multi:/home/yangyucheng/perl5/lib/perl5
	export PATH=\$PATH:$CIMS
	
	mkdir $sample.$pval
	cd $sample.$pval
	#prepare signal files (bed files) from "unique" reads
	novoalign2bed.pl -v --mismatch-file $sample.mutation.txt $dir/$sample.novoalign $sample.tag.bed
	tag2collapse.pl -v -weight --weight-in-name --keep-max-score --keep-tag-name $sample.tag.bed $sample.tag.uniq.bed
	#prepare the deletion sites
	python $CIMS/joinWrapper.py $sample.mutation.txt $sample.tag.uniq.bed 4 4 N $sample.tag.uniq.mutation.txt
	awk '{if(\$9=="-") {print \$0}}' $sample.tag.uniq.mutation.txt | cut -f 1-6 > $sample.tag.uniq.del.bed


	# Get the truncated signals
	bedExt.pl -n up -l "-1" -r "-1" -v $sample.tag.uniq.bed $sample.tag.uniq.trunc.bed
	# Clean the read-through reads/tags from the truncated signals
	cut -f 4 $sample.tag.uniq.del.bed | sort | uniq > $sample.tag.uniq.del.id 
	python $CIMS/joinWrapper.py $sample.tag.uniq.trunc.bed $sample.tag.uniq.del.id 4 1 V $sample.tag.uniq.trunc.clean.bed

	# Calcualte the clusters
	tag2cluster.pl -s -maxgap "-1" -of bed -v $sample.tag.uniq.bed $sample.tag.uniq.cluster.0.bed 
	awk '{if(\$5>2) {print \$0}}' $sample.tag.uniq.cluster.0.bed > $sample.tag.uniq.cluster.bed

	#call peaks from the clusters and signals(truncated)
	tag2peak.pl -c ./cache -ss -v -gap 25 -p $pval $sample.tag.uniq.cluster.bed $sample.tag.uniq.trunc.clean.bed $sample.tag.uniq.CITS.s30.bed
	
	echo "ALL Done"
	date
EOF
done
