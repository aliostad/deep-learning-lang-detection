
inSampleDir="/proj/b2012046/rani/analysis/gsnap/annovar"
outSampleDir="/proj/b2012046/rani/analysis/gsnap/annovar"
logdir=${outSampleDir}/info
codedir='/bubo/home/h24/alvaj/glob/code/ASE/vcf' #where varcall_merge_post_annovar_master.1.0.pl

inSamplePrefix="/all.vars.annovar."

(perl ${codedir}/varcall_merge_post_annovar_master.1.0.pl -i ${inSampleDir}${inSamplePrefix}chr1,${inSampleDir}${inSamplePrefix}chr2,${inSampleDir}${inSamplePrefix}chr3,${inSampleDir}${inSamplePrefix}chr4,${inSampleDir}${inSamplePrefix}chr5,${inSampleDir}${inSamplePrefix}chr6,${inSampleDir}${inSamplePrefix}chr7,${inSampleDir}${inSamplePrefix}chr8,${inSampleDir}${inSamplePrefix}chr9,${inSampleDir}${inSamplePrefix}chr10,${inSampleDir}${inSamplePrefix}chr11,${inSampleDir}${inSamplePrefix}chr12,${inSampleDir}${inSamplePrefix}chr13,${inSampleDir}${inSamplePrefix}chr14,${inSampleDir}${inSamplePrefix}chr15,${inSampleDir}${inSamplePrefix}chr16,${inSampleDir}${inSamplePrefix}chr17,${inSampleDir}${inSamplePrefix}chr18,${inSampleDir}${inSamplePrefix}chr19,${inSampleDir}${inSamplePrefix}chr20,${inSampleDir}${inSamplePrefix}chr21,${inSampleDir}${inSamplePrefix}chr22,${inSampleDir}${inSamplePrefix}chrX,${inSampleDir}${inSamplePrefix}chrY -nos 1 -o ${outSampleDir}/annovar_all_variants.txt >${logdir}/merge.out) >& ${logdir}/merge.err &

#${inSampleDir}${inSamplePrefix}MT
