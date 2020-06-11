inSampleDir="/proj/b2012046/rani/analysis/degner/annovar"
outSampleDir="/proj/b2012046/rani/analysis/degner/annovar"
logdir=${outSampleDir}/info
codedir='/bubo/home/h24/alvaj/glob/code/ASE/vcf' #where varcall_merge_post_annovar_master.1.0.pl

inSamplePrefix="/all.vars.annovar."

(perl ${codedir}/varcall_merge_post_annovar_master.1.0.pl -i ${inSampleDir}${inSamplePrefix}1,${inSampleDir}${inSamplePrefix}2,${inSampleDir}${inSamplePrefix}3,${inSampleDir}${inSamplePrefix}4,${inSampleDir}${inSamplePrefix}5,${inSampleDir}${inSamplePrefix}6,${inSampleDir}${inSamplePrefix}7,${inSampleDir}${inSamplePrefix}8,${inSampleDir}${inSamplePrefix}9,${inSampleDir}${inSamplePrefix}10,${inSampleDir}${inSamplePrefix}11,${inSampleDir}${inSamplePrefix}12,${inSampleDir}${inSamplePrefix}13,${inSampleDir}${inSamplePrefix}14,${inSampleDir}${inSamplePrefix}15,${inSampleDir}${inSamplePrefix}16,${inSampleDir}${inSamplePrefix}17,${inSampleDir}${inSamplePrefix}18,${inSampleDir}${inSamplePrefix}19,${inSampleDir}${inSamplePrefix}20,${inSampleDir}${inSamplePrefix}21,${inSampleDir}${inSamplePrefix}22,${inSampleDir}${inSamplePrefix}X,${inSampleDir}${inSamplePrefix}Y -nos 1 -o ${outSampleDir}/annovar_all_variants.txt >${logdir}/merge.out) >& ${logdir}/merge.err &

#${inSampleDir}${inSamplePrefix}MT
