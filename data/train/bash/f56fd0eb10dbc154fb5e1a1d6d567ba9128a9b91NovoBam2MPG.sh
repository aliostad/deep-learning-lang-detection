#!/bin/sh

module load novocraft
mkdir /data/khanlab2/patidarr/${Sample}
DATA="/data/khanlab/projects/working_DATA"
cd /data/khanlab2/patidarr/${Sample}
novoalign -c 30\
	-F STDFQ\
	-o SAM\
	-d /fdb/novoalign/chr_all_hg19.nbx\
	-f $DATA/${Sample}/${Sample}_R1.fastq.gz $DATA/${Sample}/${Sample}_R2.fastq.gz | samtools view -uS - | samtools sort -m 2000000000 - ${Sample}
samtools index ${Sample}.bam
samtools rmdup ${Sample}.bam Dedup.${Sample}.bam
samtools index Dedup.${Sample}.bam

rm -rf ${Sample}.bam ${Sample}.bam.bai
mv Dedup.${Sample}.bam ${Sample}.bam
mv Dedup.${Sample}.bam.bai ${Sample}.bam.bai

cmd="/data/khanlab/apps/Bam2mpg/scripts/bam2mpg --qual_filter 20 -bam_filter '-q31' --shorten --vcf_spec $ref --only_nonref "
ref=/data/khanlab/ref/GATK/hg19/ucsc.hg19.fasta
$cmd --region chr1 $Sample.bam --snv_vcf chr1.$Sample.snp.vcf --div_vcf chr1.$Sample.div.vcf &
$cmd --region chr2 $Sample.bam --snv_vcf chr2.$Sample.snp.vcf --div_vcf chr2.$Sample.div.vcf &
$cmd --region chr3 $Sample.bam --snv_vcf chr3.$Sample.snp.vcf --div_vcf chr3.$Sample.div.vcf &
$cmd --region chr4 $Sample.bam --snv_vcf chr4.$Sample.snp.vcf --div_vcf chr4.$Sample.div.vcf &
$cmd --region chr5 $Sample.bam --snv_vcf chr5.$Sample.snp.vcf --div_vcf chr5.$Sample.div.vcf &
$cmd --region chr6 $Sample.bam --snv_vcf chr6.$Sample.snp.vcf --div_vcf chr6.$Sample.div.vcf &
$cmd --region chr7 $Sample.bam --snv_vcf chr7.$Sample.snp.vcf --div_vcf chr7.$Sample.div.vcf &
$cmd --region chr8 $Sample.bam --snv_vcf chr8.$Sample.snp.vcf --div_vcf chr8.$Sample.div.vcf &
$cmd --region chr9 $Sample.bam --snv_vcf chr9.$Sample.snp.vcf --div_vcf chr9.$Sample.div.vcf &
$cmd --region chr10 $Sample.bam --snv_vcf chr10.$Sample.snp.vcf --div_vcf chr10.$Sample.div.vcf &
$cmd --region chr11 $Sample.bam --snv_vcf chr11.$Sample.snp.vcf --div_vcf chr11.$Sample.div.vcf &
$cmd --region chr12 $Sample.bam --snv_vcf chr12.$Sample.snp.vcf --div_vcf chr12.$Sample.div.vcf &
$cmd --region chr13 $Sample.bam --snv_vcf chr13.$Sample.snp.vcf --div_vcf chr13.$Sample.div.vcf &
$cmd --region chr14 $Sample.bam --snv_vcf chr14.$Sample.snp.vcf --div_vcf chr14.$Sample.div.vcf &
$cmd --region chr15 $Sample.bam --snv_vcf chr15.$Sample.snp.vcf --div_vcf chr15.$Sample.div.vcf &
$cmd --region chr16 $Sample.bam --snv_vcf chr16.$Sample.snp.vcf --div_vcf chr16.$Sample.div.vcf &
$cmd --region chr17 $Sample.bam --snv_vcf chr17.$Sample.snp.vcf --div_vcf chr17.$Sample.div.vcf &
$cmd --region chr18 $Sample.bam --snv_vcf chr18.$Sample.snp.vcf --div_vcf chr18.$Sample.div.vcf &
$cmd --region chr19 $Sample.bam --snv_vcf chr19.$Sample.snp.vcf --div_vcf chr19.$Sample.div.vcf &
$cmd --region chr20 $Sample.bam --snv_vcf chr20.$Sample.snp.vcf --div_vcf chr20.$Sample.div.vcf &
$cmd --region chr21 $Sample.bam --snv_vcf chr21.$Sample.snp.vcf --div_vcf chr21.$Sample.div.vcf &
$cmd --region chr22 $Sample.bam --snv_vcf chr22.$Sample.snp.vcf --div_vcf chr22.$Sample.div.vcf &
$cmd --region chrX $Sample.bam --snv_vcf chrX.$Sample.snp.vcf --div_vcf chrX.$Sample.div.vcf &
$cmd --region chrY $Sample.bam --snv_vcf chrY.$Sample.snp.vcf --div_vcf chrY.$Sample.div.vcf &
wait

for i in `seq 1 22` X Y 
	do
		bgzip chr${i}.$Sample.div.vcf
		bgzip chr${i}.$Sample.snp.vcf
		tabix -p vcf chr${i}.$Sample.div.vcf.gz
		tabix -p vcf chr${i}.$Sample.snp.vcf.gz
	done

vcf-concat *.$Sample.div.vcf.gz  >$Sample.div.vcf
vcf-concat *.$Sample.snp.vcf.gz  >$Sample.snp.vcf
/data/khanlab/apps/annovar/convert2annovar.pl $Sample.div.vcf --includeinfo |cut -f 1-6,10 |sed -e 's/:/\t/g'|sed 's/,/\t/g' |cut -f 1-6,9,10,11|awk '{OFS="\t"}; {if($6 >=10) print $0}' |awk '{OFS="\t"}; {if($7 >=10) print $1,$2,$3,$4,$5,$6,$7,$8,$9,$9/$7}'|awk '{OFS="\t"}; {if($10 >=0.1) print $0}' >$Sample.div.txt

/data/khanlab/apps/annovar/convert2annovar.pl $Sample.snp.vcf --includeinfo |cut -f 1-6,10 |sed -e 's/:/\t/g'|sed 's/,/\t/g' |cut -f 1-6,9,10,11|awk '{OFS="\t"}; {if($6 >=10) print $0}' |awk '{OFS="\t"}; {if($7 >=10) print $1,$2,$3,$4,$5,$6,$7,$8,$9,$9/$7}'|awk '{OFS="\t"}; {if($10 >=0.1) print $0}' >$Sample.snp.txt
cat $Sample.div.txt $Sample.snp.txt |sort -n >$Sample.bam2mpg.txt
rm -rf chr*
