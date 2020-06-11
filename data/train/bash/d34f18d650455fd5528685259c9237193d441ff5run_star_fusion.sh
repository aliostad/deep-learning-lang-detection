#! /bin/sh

base_dir=../analysis/ATL/result/genomon_rna/star_fusion

while read sample; 
do
<<_COMMENT_OUT_
    echo "python filter_star_fusion.py ${base_dir}/${sample}/${sample}.fusion_candidates.txt 3 > ${base_dir}/${sample}/${sample}.fusion_candidates.filt.txt" 
    python filter_star_fusion.py ${base_dir}/${sample}/${sample}.fusion_candidates.txt 3 > ${base_dir}/${sample}/${sample}.fusion_candidates.filt.txt 
   
    echo "python fusion2SV.py ${base_dir}/${sample}/${sample}.fusion_candidates.filt.txt ../analysis/ATL/data/SV/${sample}.genomonSV.result.txt ${base_dir}/${sample}/${sample}.fusion_candidates.filt.SV.txt star_fusion /home/yshira/bin/bedtools-2.17.0/bin" 
    python fusion2SV.py ${base_dir}/${sample}/${sample}.fusion_candidates.filt.txt ../analysis/ATL/data/SV/${sample}.genomonSV.result.txt ${base_dir}/${sample}/${sample}.fusion_candidates.filt.SV.txt star_fusion /home/yshira/bin/bedtools-2.17.0/bin
_COMMENT_OUT_

    echo "python SV_count.py ${base_dir}/${sample}/${sample}.fusion_candidates.filt.SV.txt"
    python SV_count.py ${base_dir}/${sample}/${sample}.fusion_candidates.filt.SV.txt

done < ../analysis/ATL/data/sample_list_ATL.txt

