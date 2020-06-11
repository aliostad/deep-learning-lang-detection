clinseq_model=$1
echo "Exome Normal:"
genome model list id=$clinseq_model  \
    --show exome_model.normal_model.last_succeeded_build.merged_alignment_result.bam_path | tail -1
echo "Exome Tumor:"
genome model list id=$clinseq_model  \
    --show exome_model.tumor_model.last_succeeded_build.merged_alignment_result.bam_path | tail -1
echo "WGS Normal:"
genome model list id=$clinseq_model  \
    --show wgs_model.normal_model.last_succeeded_build.merged_alignment_result.bam_path | tail -1
echo "WGS Tumor:"
genome model list id=$clinseq_model  \
    --show wgs_model.tumor_model.last_succeeded_build.merged_alignment_result.bam_path | tail -1
echo "Normal RNAseq:"
genome model clin-seq list id=${clinseq_model} \
    --show normal_rnaseq_model.last_succeeded_build.alignment_result.bam_path | tail -1
echo "Tumor RNAseq:"
genome model clin-seq list id=${clinseq_model} \
    --show tumor_rnaseq_model.last_succeeded_build.alignment_result.bam_path | tail -1



