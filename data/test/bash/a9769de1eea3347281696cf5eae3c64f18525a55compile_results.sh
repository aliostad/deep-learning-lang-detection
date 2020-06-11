fullfilename=$1
filename=$(basename $fullfilename)
sampleID=${filename%".trimmed.fq_bismark.coordsorted.methylkit.md"}
echo $sampleID
newfile=${sampleID}temp.txt

sed 's/$/  /g' ${sampleID}.fastq_trimming_report.txt >${sampleID}.trimming.report.tmp
sed 's/$/  /g' ${sampleID}.trimmed.fq_Bismark_mapping_report.txt >${sampleID}.mapping.report.tmp

echo -e "\n#RRBS QC Report for sample" "$sampleID  \n" >>${sampleID}_QC_report.md

echo -e "\n##Quality and Adapter Trimming Report  \n" >>${sampleID}_QC_report.md
cat ${sampleID}.trimming.report.tmp  >>${sampleID}_QC_report.md
echo -e "\n[FASTQC before trimming](./fastqc/$sampleID.fastq/pretrim/${sampleID}_fastqc/fastqc_report.html)\n" >>${sampleID}_QC_report.md
echo -e "\n[FASTQC after  trimming](./fastqc/$sampleID.fastq/posttrim/$sampleID.trimmed.fq_fastqc/fastqc_report.html)\n" >>${sampleID}_QC_report.md


echo -e "\n##Bismark Alignment Report  \n" >>${sampleID}_QC_report.md
cat ${sampleID}.mapping.report.tmp >>${sampleID}_QC_report.md

cat $filename >>${sampleID}_QC_report.md

rm ${sampleID}.mapping.report.tmp
rm ${sampleID}.trimming.report.tmp

pandoc -f markdown-yaml_metadata_block -t html -c http://dl.dropboxusercontent.com/u/4253254/CSS/GitHub2.css ${sampleID}_QC_report.md -o ${sampleID}_QC_report.html
