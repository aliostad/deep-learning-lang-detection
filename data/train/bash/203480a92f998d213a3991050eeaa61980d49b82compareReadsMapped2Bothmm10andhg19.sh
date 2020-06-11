
sample="1"

cd /nearline/gardner/biomarker/RNAseq/WangLab/LinC/$sample/align/gsnap

refGenome="hg19"
samtools view -F 4 $refGenome/$sample"_gsnap."$refGenome".bam"| cut -f1|sort|uniq > $refGenome/$sample"_"$refGenome"_mapped_id.txt"

refGenome="mm10"
samtools view -F 4 $refGenome/$sample"_gsnap."$refGenome".bam"| cut -f1|sort|uniq > $refGenome/$sample"_"$refGenome"_mapped_id.txt"

# grep -F -f test1.txt test3.txt
## Find uniq read Ids that were mapped to both mm10 and hg19:
sort hg19/$sample"_hg19_mapped_id.txt" mm10/$sample"_mm10_mapped_id.txt" | awk 'dup[$0]++ == 1'> duplicated_mappedId_hg19_mm10.txt

###
# 

