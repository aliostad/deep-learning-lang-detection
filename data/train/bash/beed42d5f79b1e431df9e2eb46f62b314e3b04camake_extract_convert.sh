SAMPLE=$1
DIR=/rhome/jinghuas/bin
PWD=`pwd`
SUFFIX=p1.fq_bismark_bt2_pe.deduplicated.txt

echo "
#PBS -q highmem
#PBS -l mem=30g

module load bismark
cd $PWD 

if [ ! -e ${SAMPLE}.${SAMPLE}.p1.fq_bismark_bt2_pe.deduplicated.sam  ]; then
  deduplicate_bismark_alignment_output.pl -p ${SAMPLE}.${SAMPLE}.p1.fq_bismark_bt2_pe.sam
fi

if [ ! -e CHH_${SAMPLE}.bismarkextract.out.sorted ]; then
  bismark_methylation_extractor  --no_overlap -p ${SAMPLE}.${SAMPLE}.p1.fq_bismark_bt2_pe.deduplicated.sam --report
fi
"


for TYPE in CHH CpG CHG ; do
  echo "
  if [ ! -e  ${TYPE}_${SAMPLE}.bismarkextract.out.sorted ]; then
    cat ${TYPE}_OB_${SAMPLE}.${SAMPLE}.${SUFFIX} ${TYPE}_OT_${SAMPLE}.${SAMPLE}.${SUFFIX} > ${TYPE}_${SAMPLE}.bismarkextract.out
    rm ${TYPE}_OB_${SAMPLE}.${SAMPLE}.${SUFFIX} ${TYPE}_OT_${SAMPLE}.${SAMPLE}.${SUFFIX}
    sort -k3 ${TYPE}_${SAMPLE}.bismarkextract.out | grep -v Bismark > ${TYPE}_${SAMPLE}.bismarkextract.out.sorted
    rm ${TYPE}_${SAMPLE}.bismarkextract.out
  fi
  #convert to wig
  perl $DIR/convert_extracted_methylation_2_wig_noFasta.pl ${TYPE}_${SAMPLE}.bismarkextract.out.sorted > ${TYPE}_${SAMPLE}.wig

  perl $DIR/split_methyl_many_files_noFasta.pl ${TYPE}_${SAMPLE}.bismarkextract.out.sorted
  "
done

