#! /usr/bin/bash

###########################################
# take sorted and indexed bam file as input
# realigne the bam file around indels
# recalibrate the bam file on non-dbsnp sites
# call variants with GATK haplotypecaller
# apply a hard filter on SNPs and Indels
###########################################


## setup parameters
source parameters.sh

SampleId=$1
bamfile=$2
outputDir=$3

echo $SampleId $outputDir 

## Local Realignment around Indels
$java -jar -Xmx$javaMem $gatk -T RealignerTargetCreator -nt $thread -I $bamfile --downsample_to_fraction 1.0 -R $refFasta -o $outputDir/$SampleId.intervals
$java -jar -Xmx$javaMem $gatk -I $bamfile -R $refFasta -T IndelRealigner --downsample_to_fraction 1.0 -targetIntervals $outputDir/$SampleId.intervals -o $outputDir/$SampleId.realigne.bam
checkError "Local Realignment around Indels" $SampleId

## Recalibrate by base quality
$java -jar -Xmx$javaMem $gatk -T BaseRecalibrator -nct $thread -I $outputDir/$SampleId.realigne.bam --downsample_to_fraction 1.0 -R $refFasta -knownSites $refDbsnp -o $outputDir/$SampleId.recal.grp
$java -jar -Xmx$javaMem $gatk -T PrintReads -nct $thread -R $refFasta -I $outputDir/$SampleId.realigne.bam --downsample_to_fraction 1.0 -BQSR $outputDir/$SampleId.recal.grp -o $outputDir/$SampleId.realigne.recal.bam
checkError "Recalibrate by base quality" $SampleId
rm $outputDir/$SampleId.intervals $outputDir/$SampleId.realigne.ba* $outputDir/$SampleId.recal.grp


## call variants using haplotypecaller
$java -jar -Xmx$javaMem $gatk -T HaplotypeCaller -nct $thread -I $outputDir/$SampleId.realigne.recal.bam --downsample_to_fraction 1.0 -R $refFasta --interval_padding 1 -o $outputDir/$SampleId.haplotypeCaller.vcf
checkError "call variants using haplotypecaller" $SampleId

## keep heterozygous variants
cat  $outputDir/$SampleId.haplotypeCaller.vcf | $java  -jar $snpEffDir/SnpSift.jar filter "( GEN[0].GT == '0/1' ) & ( GEN[0].GQ > 30 )" > $outputDir/$SampleId.haplotypeCaller.hetero.vcf

## extract and filter SNPs
$java -jar -Xmx$javaMem $gatk -T SelectVariants -R $refFasta -V $outputDir/$SampleId.haplotypeCaller.hetero.vcf  $target -selectType SNP -o $outputDir/$SampleId.haplotypeCaller.hetero.snp.vcf
$java -jar -Xmx$javaMem $gatk -T VariantFiltration -R $refFasta -V $outputDir/$SampleId.haplotypeCaller.hetero.snp.vcf --filterExpression "QD < 2.0 || FS > 60.0 || MQ <40.0 || MQRankSum < -12.5 || ReadPosRankSum < -8.0" --filterName "Filtered" -o $outputDir/$SampleId.haplotypeCaller.hetero.filtered.snp.vcf

checkError "extract and filter SNPs" $SampleId

cat $outputDir/$SampleId.haplotypeCaller.hetero.filtered.snp.vcf | $java -jar $snpEffDir/SnpSift.jar filter "( na FILTER ) | (FILTER = 'PASS')" >  $outputDir/$SampleId.haplotypeCaller.hetero.filtered.vcf.tmp


## extract and filter Indels
$java -jar -Xmx$javaMem $gatk -T SelectVariants -R $refFasta -V $outputDir/$SampleId.haplotypeCaller.hetero.vcf  $target -selectType INDEL -o $outputDir/$SampleId.haplotypeCaller.hetero.indel.vcf
$java -jar -Xmx$javaMem $gatk -T VariantFiltration -R $refFasta -V $outputDir/$SampleId.haplotypeCaller.hetero.indel.vcf --filterExpression "QD < 2.0 || FS > 200.0 || ReadPosRankSum < -20.0" --filterName "Filtered" -o $outputDir/$SampleId.haplotypeCaller.hetero.filtered.indel.vcf

checkError "extract and filter Indels" $SampleId

grep -v "^#" $outputDir/$SampleId.haplotypeCaller.hetero.filtered.indel.vcf | grep "PASS" >> $outputDir/$SampleId.haplotypeCaller.hetero.filtered.vcf.tmp
mv $outputDir/$SampleId.haplotypeCaller.hetero.filtered.vcf.tmp  $outputDir/$SampleId.haplotypeCaller.hetero.filtered.vcf

## sort vcf 
$vcfsort -c $outputDir/$SampleId.haplotypeCaller.hetero.filtered.vcf > $outputDir/$SampleId.haplotypeCaller.hetero.filtered.vcf.tmp
checkError "sort vcf" $SampleId

mv $outputDir/$SampleId.haplotypeCaller.hetero.filtered.vcf.tmp  $outputDir/$SampleId.haplotypeCaller.hetero.filtered.vcf


## clean up
rm $outputDir/$SampleId.*.snp.*  $outputDir/$SampleId.*.indel.* 


