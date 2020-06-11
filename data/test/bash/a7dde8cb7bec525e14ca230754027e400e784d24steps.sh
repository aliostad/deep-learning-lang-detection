parallel bgzip ::: *vcf
parallel tabix -p vcf ::: *gz
vcf-isec -f Sample-1.flt.vcf.gz Sample-2.flt.vcf.gz > Sample-1-isec.flt.vcf
vcf-isec -f Sample-2.flt.vcf.gz Sample-1.flt.vcf.gz > Sample-2-isec.flt.vcf
vcf-isec -f Sample-3.flt.vcf.gz Sample-4.flt.vcf.gz > Sample-3-isec.flt.vcf
vcf-isec -f Sample-4.flt.vcf.gz Sample-3.flt.vcf.gz > Sample-4-isec.flt.vcf
parallel bgzip -d ::: *gz
vcf-annotate -H -f Q=20/d=5 Sample-1-isec.flt.vcf > Sample-1.PASS.vcf
vcf-annotate -H -f Q=20/d=5 Sample-2-isec.flt.vcf > Sample-2.PASS.vcf
vcf-annotate -H -f Q=20/d=5 Sample-3-isec.flt.vcf > Sample-3.PASS.vcf
vcf-annotate -H -f Q=20/d=5 Sample-4-isec.flt.vcf > Sample-4.PASS.vcf
vcf-annotate -H -f Q=20/d=5 Sample-5.flt.vcf > Sample-5.PASS.vcf
vcf-annotate -H -f Q=20/d=5 Sample-6.flt.vcf > Sample-6.PASS.vcf
vcf-annotate -H -f Q=20/d=5 Sample-7.flt.vcf > Sample-7.PASS.vcf
vcf-annotate -H -f Q=20/d=5 Sample-8.flt.vcf > Sample-8.PASS.vcf
vcf-annotate -H -f Q=20/d=5 Sample-9.flt.vcf > Sample-9.PASS.vcf
vcf-annotate -H -f Q=20/d=5 Sample-10.flt.vcf > Sample-10.PASS.vcf
vcf-annotate -H -f Q=20/d=5 Sample-11.flt.vcf > Sample-11.PASS.vcf
perl run_snpeff.pl
perl merge.pl
head -n 1 merged.txt | cut -f17,18,19 --complement > head10
head -n 1 merged.txt > head11
grep -vP "\tSYNONYMOUS" merged.txt > merged_no_syn.txt
cut -f17,18,19 --complement merged_no_syn.txt > merged_no_syn_no_11.txt
grep -vP "\t\t" merged_no_syn_no_11.txt > common_to_all_10.txt
cat head10 > merged_mutations_for_1-10.txt && grep -P "\t\t" merged_no_syn_no_11.txt >> merged_mutations_for_1-10.txt
grep -vP "\t\t" merged_no_syn.txt > common_to_all_11.txt
cat head11 > merged_mutations_for_1-11.txt && grep -P "\t\t" merged_no_syn.txt >> merged_mutations_for_1-11.txt
