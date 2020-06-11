

VCF_DIR=/home/julyin/variant_calling_final/finalitas/snvs_using_mutect/filtered
OUT_DIR=/home/julyin/variant_calling_final/finalitas/snvs_using_mutect/filtered_allelefreq/

cd /share/ClusterShare/software/contrib/julyin/vcflib

while read sample;
do
    ./vcffilter -s -g "FA > 0.1" ${VCF_DIR}/$sample.mutect.filtered.vcf > ${OUT_DIR}/$sample.mutect.filtered.allelfreq.unfinished.vcf

    #head -110 ${OUT_DIR}/$sample.mutect.filtered.allelfreq.unfinished.vcf >  ${OUT_DIR}/$sample.header
    #grep -v '.|.' ${OUT_DIR}/$sample.mutect.filtered.allelfreq.unfinished.vcf > ${OUT_DIR}/$sample.headless_allelefreq
    #cat ${OUT_DIR}/$sample.header ${OUT_DIR}/$sample.headless_allelefreq > ${OUT_DIR}/$sample.mutect.filtered.allelfreq.vcf

    #rm ${OUT_DIR}/$sample.header
    #rm ${OUT_DIR}/$sample.headless_allelefreq


    awk '$10 != "." || $11 !="." {print;}' ${OUT_DIR}/$sample.mutect.filtered.allelfreq.unfinished.vcf > ${OUT_DIR}/$sample.mutect.filtered.allelfreq.vcf

    rm ${OUT_DIR}/$sample.mutect.filtered.allelfreq.unfinished.vcf


done < /home/julyin/variant_calling_final/finalitas/snvs_using_mutect/filtered/files_for_vcffilter.txt





