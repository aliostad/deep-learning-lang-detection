fullfilename=$1
filename=$(basename $fullfilename)
sampleID=${filename%_R1.val_1.fq_bismark_pe.coordsorted.methylkit.md}
sampleID1="${sampleID}_R1"
sampleID2="${sampleID}_R2"
QCreport="${sampleID}_QC_report.md"

echo $sampleID1
echo $sampleID2

# title
echo -e "\n#RRBS QC Report for sample" "$sampleID  \n" >>$QCreport

# trimming reports
echo -e "\n##Quality and Adapter Trimming Reports\n" >>$QCreport
## sample1
echo -e "###${sampleID1}\n" >>$QCreport 
sed 's/$/  /g' ${sampleID1}.fastq_trimming_report.txt | sed 's/=/ /g' >${sampleID1}.trimming.report.tmp
cat ${sampleID1}.trimming.report.tmp  >>$QCreport
echo -e "\n[FASTQC before trimming](./fastqc/pretrim/${sampleID1}_fastqc/fastqc_report.html)\n" >>$QCreport 
echo -e "\n[FASTQC after  trimming](./fastqc/posttrim/${sampleID1}_val_1.fq_fastqc/fastqc_report.html)\n" >>$QCreport
#sample2
echo -e "###${sampleID2}\n" >>$QCreport 
sed 's/$/  /g' ${sampleID2}.fastq_trimming_report.txt | sed 's/=/ /g' >${sampleID2}.trimming.report.tmp
cat ${sampleID2}.trimming.report.tmp  >>$QCreport
echo -e "\n[FASTQC before trimming](./fastqc/pretrim/${sampleID2}_fastqc/fastqc_report.html)\n" >>$QCreport 
echo -e "\n[FASTQC after  trimming](./fastqc/posttrim/${sampleID2}_val_2.fq_fastqc/fastqc_report.html)\n" >>$QCreport

# mapping report
echo -e "\n##Bismark Alignment Report  \n" >>$QCreport
if [ -f ${sampleID1}.val_1.fq_Bismark_paired-end_mapping_report.txt ]
then 
	sed 's/$/  /g' ${sampleID1}.val_1.fq_Bismark_paired-end_mapping_report.txt >${sampleID1}.mapping.report.tmp
	cat ${sampleID1}.mapping.report.tmp >>$QCreport 
	rm ${sampleID1}.mapping.report.tmp
else
	echo "${sampleID1}_val_1.fq_Bismark_paired-end_mapping_report.txt not found"
fi

# methylKit report
if [ -f ${sampleID1}.val_1.fq_bismark_pe.coordsorted.methylkit.md ]
then
	cat ${sampleID1}.val_1.fq_bismark_pe.coordsorted.methylkit.md >>$QCreport
else
	echo "${sampleID1}.val_1.fq_bismark_pe.coordsorted.methylkit.md not found"
fi

# cleanup
rm ${sampleID1}.trimming.report.tmp
rm ${sampleID2}.trimming.report.tmp

#convert to html
pandoc -f markdown-yaml_metadata_block -t html -c http://dl.dropboxusercontent.com/u/4253254/CSS/GitHub2.css $QCreport -o ${sampleID}_QC_report.html
