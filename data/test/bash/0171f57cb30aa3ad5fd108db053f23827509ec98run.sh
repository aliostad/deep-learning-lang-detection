#!/bin/bash

#echo "Combining Lane Data from Fastq's"

#cat $1 > Sample_Forward.fastq
#cat $2 >> Sample_Forward.fastq
#cat $3 > Sample_Reverse.fastq
#cat $4 >> Sample_Reverse.fastq

mkdir ./Sample_Results

echo "Performing Alignment"

time /storage/code_repos/run_seq.py -f $1 -r $2 -l illumina --lane 1 -t 10 -s sample_name -o ./Sample_Results/ -g hg38

echo "Performing Variant Calling"

time java -jar /home/sravishankar9/tools/GATK/GenomeAnalysisTK.jar -T HaplotypeCaller -R /storage/Human_igenome/Homo_sapiens/UCSC/hg38/Sequence/WholeGenomeFasta/genome.fa -I ./Sample_Results/sample_name1/sample_name_RD_ir.bam --dbsnp /storage/Human_igenome/Homo_sapiens/UCSC/hg38/Annotation/dbSNP/genome.vcf.gz -o ./Sample_Results/sample_name1/sample_name.vcf -nct 10 -L /home/yasvanth3/ahcg/cancergenomics/2015Fall/nexterarapidcapture_exome_targetedregions_v1.2.hg38.bed

echo "Filtering Variants"

time java -jar /home/yasvanth3/ahcg/cancergenomics/2015Fall/tools/snpEff/SnpSift.jar filter "( QUAL >= 30 ) &  ( DP >= 20 ) & ( QD >= 2.0 ) &  ( FS <= 60 )" ./Sample_Results/sample_name1/sample_name.vcf > ./Sample_Results/sample_name1/sample_name_filtered.vcf

echo "Annotating Variants with Annovar"

time /home/sravishankar9/tools/annovar/table_annovar.pl ./Sample_Results/sample_name1/sample_name_filtered.vcf /home/yasvanth3/ahcg/cancergenomics/2015Fall/tools/annovar-db/ -buildver hg38 -out ./Sample_Results/sample_name1/sample_name_filt -remove -protocol refGene,esp6500siv2_all,ljb26_all,nci60,clinvar_20150629,cosmic70,knownGene -operation g,f,f,f,f,f,f -nastring . -vcfinput

#echo "Extracting nonsynonymous mutations from Gene Panel"
#grep -f panel.txt ./Sample_Results/sample_name1/sample_name_annotated.vcf | grep -f 'stop_gain_mutations' | grep 'nonsyn' > sample_color_panel results
