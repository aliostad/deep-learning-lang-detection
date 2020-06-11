#!/bzin/bash

FILE1="$1"

sample_name="$3"

mkdir inter_files
mkdir inter_files/$sample_name.dir
mkdir pipe_logs
mkdir variants

echo  "Trimming Files" >> pipe_logs/$sample_name.log

java -jar trimmomatic-0.30.jar SE -threads 2 \
-phred33 -trimlog inter_files/$sample_name.dir/trimming.log $FILE1 inter_files/$sample_name.dir/$sample_name.trimmed \
ILLUMINACLIP:<directory_to_adapter_file>TruSeq3-PE.fa:2:30:10 \
LEADING:3 TRAILING:3 \
SLIDINGWINDOW:4:20 MINLEN:36

#make sure that you have already created a SNPiR index using bwa index
#bwa forward and reverse
echo "Aligning trimmed forward file to SNPiR.fa" >> pipe_logs/$sample_name.log
bwa mem -t 4 annot_files/SNPiR.fa inter_files/$sample_name.dir/$sample_name.trimmed  \
> inter_files/$sample_name.dir/$sample_name.forward.sam


#Convert Coordinates
echo "Converting coordinates of aligned file to SNPiR format" >> pipe_logs/$sample_name.log
java -Xmx2g -classpath <SNPiR_directory> convertCoordinates < inter_files/$sample_name.dir/$sample_name.forward.sam > inter_files/$sample_name.dir/$sample_name.converted.sam

#Convert sam files to bam files
echo "Converting sam to bam" >> pipe_logs/$sample_name.log
samtools view -bS inter_files/$sample_name.dir/$sample_name.converted.sam > inter_files/$sample_name.dir/$sample_name.converted.bam

#Sorting bam file
echo "Sorting bam file." >> pipe_logs/$sample_name.log
samtools sort inter_files/$sample_name.dir/$sample_name.converted.bam  inter_files/$sample_name.dir/$sample_name.converted.sorted

if [ -s inter_files/$sample_name.dir/$sample_name.converted.sorted.bam ];
then 
	rm inter_files/$sample_name.dir/$sample_name.converted.bam
        rm inter_files/$sample_name.dir/$sample_name.converted.sam
        rm inter_files/$sample_name.dir/$sample_name.merged.sam
        . 
fi
 
#Make sure that there is a reference dictionary created by picard before using picard tools
echo "Removing duplicates with Picard" >> pipe_logs/$sample_name.log
java -Xmx2g -jar <directory_to_picardTools>/MarkDuplicates.jar INPUT=inter_files/$sample_name.dir/$sample_name.converted.sorted.bam \
OUTPUT=inter_files/$sample_name.dir/$sample_name.rmdup.bam METRICS_FILE=inter_files/$sample_name.dir/$sample_name.picard_info.txt \
REMOVE_DUPLICATES=true ASSUME_SORTED=true VALIDATION_STRINGENCY=SILENT

if [ -s inter_files/$sample_name.dir/$sample_name.rmdup.bam ];
then 
        rm inter_files/$sample_name.dir/$sample_name.converted.sorted.bam
        . 
fi

#Change options as necessary
echo "Add read group info (required for GATK)" >> pipe_logs/$sample_name.log
java -Xmx2g -jar <directory_to_picardTools>/AddOrReplaceReadGroups.jar INPUT=inter_files/$sample_name.dir/$sample_name.rmdup.bam OUTPUT=inter_files/$sample_name.dir/$sample_name.filtered_w_RG.bam RGLB=$sample_name RGPL=Illumina RGPU=Lane1 RGSM=$sample_name VALIDATION_STRINGENCY=SILENT

if [ -s inter_files/$sample_name.dir/$sample_name.filtered_w_RG.bam ];
then 
        rm inter_files/$sample_name.dir/$sample_name.rmdup.bam
        . 
fi


echo "reordering bam" >> pipe_logs/$sample_name.log
java -Xmx2g -jar <directory_to_picardTools>/ReorderSam.jar INPUT=inter_files/$sample_name.dir/$sample_name.filtered_w_RG.bam output=inter_files/$sample_name.dir/$sample_name.sorted.bam REFERENCE=annot_files/SNPiR.fa VALIDATION_STRINGENCY=SILENT


if [ -s inter_files/$sample_name.dir/$sample_name.sorted.bam ];
then 
        rm inter_files/$sample_name.dir/$sample_name.filtered_w_RG.bam
        . 
fi

echo "filtering unmapped reads" >> pipe_logs/$sample_name.log
samtools view -b -F 4  inter_files/$sample_name.dir/$sample_name.sorted.bam > inter_files/$sample_name.dir/$sample_name.filtered.bam

if [ -s inter_files/$sample_name.dir/$sample_name.filtered.bam ];
then 
        rm inter_files/$sample_name.dir/$sample_name.sorted.bam
        . 
fi

echo "create index for bam" >> pipe_logs/$sample_name.log
samtools index inter_files/$sample_name.dir/$sample_name.filtered.bam

touch  inter_files/$sample_name.dir/$sample_name.intervals

echo "indel realigner" >> pipe_logs/$sample_name.log
java -jar <directory_to_GATK>/GenomeAnalysisTK.jar -T IndelRealigner   -R annot_files/genome.fa  -I inter_files/$sample_name.dir/$sample_name.filtered.bam -targetIntervals inter_files/$sample_name.dir/$sample_name.intervals -o inter_files/$sample_name.dir/$sample_name.indel.aligned.bam -U ALLOW_N_CIGAR_READS --maxReadsForRealignment 100000

echo "BaseRecalibrator(creates grp file)" >> pipe_logs/$sample_name.log
java -Xmx4g -jar <directory_to_GATK>/GenomeAnalysisTK.jar  -T BaseRecalibrator -nct 24 -I inter_files/$sample_name.dir/$sample_name.indel.aligned.bam  -R annot_files/genome.fa  -U ALLOW_N_CIGAR_READS   -knownSites annot_files/dbsnp_hg19.vcf -o inter_files/$sample_name.dir/$sample_name.grp

echo "Print Reads (creates recalibrated bam from grp file)" >> pipe_logs/$sample_name.log
java -jar <directory_to_GATK>/GenomeAnalysisTK.jar -T PrintReads -nct 24 -R annot_files/genome.fa -I inter_files/$sample_name.dir/$sample_name.indel.aligned.bam -U ALLOW_N_CIGAR_READS -BQSR inter_files/$sample_name.dir/$sample_name.grp -o inter_files/$sample_name.dir/$sample_name.final.bam

if [ -s inter_files/$sample_name.dir/$sample_name.final.bam ];
then 
        rm inter_files/$sample_name.dir/$sample_name.filtered.bam
        rm inter_files/$sample_name.dir/$sample_name.indel.aligned.bam
        . 
fi

echo "UnifiedGenotyper" >> pipe_logs/$sample_name.log
java -jar <directory_to_GATK>/GenomeAnalysisTK.jar -T UnifiedGenotyper  -nct 24 -R annot_files/genome.fa -I inter_files/$sample_name.dir/$sample_name.final.bam --dbsnp annot_files/dbsnp_hg19.vcf -o inter_files/$sample_name.dir/$sample_name.snps.raw.vcf -stand_call_conf 0 -stand_emit_conf 0  -U ALLOW_N_CIGAR_READS --output_mode EMIT_VARIANTS_ONLY -glm SNP

echo "Convert vcf to SNPiR format (using SNPiR tool)" >> pipe_logs/$sample_name.log
sh <directory_to_SNPiR>/convertVCF.sh inter_files/$sample_name.dir/$sample_name.snps.raw.vcf inter_files/$sample_name.dir/$sample_name.snpir.txt 20

echo "filter mismatches at read end" >> pipe_logs/$sample_name.log
perl <directory_to_SNPiR>/filter_mismatch_first6bp.pl -infile inter_files/$sample_name.dir/$sample_name.snpir.txt -outfile inter_files/$sample_name.dir/$sample_name.snpir.trimmed.txt -bamfile inter_files/$sample_name.dir/$sample_name.final.bam

echo "Remove variants that lie in repetitive regions" >> pipe_logs/$sample_name.log
awk '{OFS="\t";$2=$2-1"\t"$2;print $0}' inter_files/$sample_name.dir/$sample_name.snpir.trimmed.txt | intersectBed -a stdin -b annot_files/hg19_rmsk -v | cut -f1,3-7 > inter_files/$sample_name.dir/$sample_name.snpir.rmsk.txt

echo "Filter variants in intronic regions (on this step)" >> pipe_logs/$sample_name.log
perl <directory_to_SNPiR>/filter_intron_near_splicejuncts.pl -infile inter_files/$sample_name.dir/$sample_name.snpir.rmsk.txt -outfile inter_files/$sample_name.dir/$sample_name.snpir.rmsk.rmintron.txt -genefile annot_files/gene_file_sorted

echo "filter variants in homopolymers" >> pipe_logs/$sample_name.log
perl <directory_to_SNPiR>/filter_homopolymer_nucleotides.pl -infile inter_files/$sample_name.dir/$sample_name.snpir.rmsk.rmintron.txt -outfile inter_files/$sample_name.dir/$sample_name.snpir.rmsk.rmintron.rmhom.txt -refgenome annot_files/genome.fa


echo "filter variants that were caused by mismapped reads" >> pipe_logs/$sample_name.log
perl S<directory_to_SNPiR>/BLAT_candidates.pl -infile inter_files/$sample_name.dir/$sample_name.snpir.rmsk.rmintron.rmhom.txt -outfile inter_files/$sample_name.dir/$sample_name.snpir.rmsk.rmintron.rmhom.rmblat.txt -bamfile inter_files/$sample_name.dir/$sample_name.final.bam -refgenome annot_files/genome.fa


echo "remove known RNA editing sites" >> pipe_logs/$sample_name.log
awk '{OFS="\t";$2=$2-1"\t"$2;print $0}' inter_files/$sample_name.dir/$sample_name.snpir.rmsk.rmintron.rmhom.rmblat.txt | intersectBed -a stdin -b annot_files/Human_AG_all_hg19.bed -v > variants/$sample_name.variants.bed 

if [ -s inter_files/$sample_name.dir/$sample_name.variants.bed ];
then 
	mv inter_files/$sample_name.dir/$sample_name.variants.bed variants/
        rm -r inter_files/$sample_name.dir/
        . 
fi

echo "It finished running! Happy hunting!" >> pipe_logs/$sample_name.log
