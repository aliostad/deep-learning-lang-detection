#!/bin/bash

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
dataset_name="oncochip_n_twin_chr9"
project_out_dir="$PLINK_OUTPUT_DIR/chr9/online/linkage_9q"
project_code="b2011097"
jobs_setup_file="$dataset_name"_jobs_setup.txt
input_dna_regions="9:98382949-98550265"
hap_window_sizes="10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25"
input_bfile_prefix="$GENOTYPING_ONCOCHIP_N_TWINGENE"
phenotype_file="$GENOTYPING_ONCOCHIP_N_TWINGENE_PHENOTYPE_FILE"
filter_criteria="PVALUE005"
filter_criteria+=",DISEASE_SNP"
cutoff_pvalue="0.001"
cutoff_ors="1.5"
fam_hap_prefix="$HAPLOTYPE_CHR9_LINKAGE"
sample_info="24:new_fam24_shared_only"
sample_info+=",8:fam_8"
sample_info+=",275:fam_275"
sample_info+=",350:fam_350"
sample_info+=",478:fam_478"
sample_info+=",740:fam_740"
sample_info+=",918:fam_918"
#sample_info+=",12:fam_12"
#sample_info+=",26:fam_26"
#sample_info+=",46:fam_46"
#sample_info+=",60:fam_60"
#sample_info+=",68:fam_68"
#sample_info+=",70:fam_70"
#sample_info+=",87:fam_87"
#sample_info+=",91:fam_91"
#sample_info+=",94:fam_94"
#sample_info+=",103:fam_103"
#sample_info+=",110:fam_110"
#sample_info+=",134:fam_134"
#sample_info+=",155:fam_155"
#sample_info+=",161:fam_161"
#sample_info+=",181:fam_181"
#sample_info+=",191:fam_191"
#sample_info+=",208:fam_208"
#sample_info+=",214:fam_214"
#sample_info+=",216:fam_216"
#sample_info+=",221:fam_221"
#sample_info+=",227:fam_227"
#sample_info+=",231:fam_231"
#sample_info+=",237:fam_237"
#sample_info+=",242:fam_242"
#sample_info+=",264:fam_254"
#sample_info+=",288:fam_288"
#sample_info+=",301:fam_301"
#sample_info+=",306:fam_306"
#sample_info+=",309:fam_309"
#sample_info+=",315:fam_315"
#sample_info+=",322:fam_322"
#sample_info+=",325:fam_325_shared_only"
#sample_info+=",340:fam_340"
#sample_info+=",348:fam_348"
#sample_info+=",397:fam_397"
#sample_info+=",409:fam_409"
#sample_info+=",415:fam_415"
#sample_info+=",425:fam_425"
#sample_info+=",470:fam_470"
#sample_info+=",479:fam_479"
#sample_info+=",547:fam_547"
#sample_info+=",578:fam_578"
#sample_info+=",660:fam_660"
#sample_info+=",695:fam_695"
#sample_info+=",704:fam_704"
#sample_info+=",869:fam_869"
#sample_info+=",1025:fam_1025"
#sample_info+=",1085:fam_1085"
#sample_info+=",1128:fam_1128"
#sample_info+=",1207:fam_1207"
#sample_info+=",1213:fam_1213"
#sample_info+=",1252:fam_1252"
#sample_info+=",1290:fam_1290"
#sample_info+=",1425:fam_1425"


cmd="pyCMM-plink-create-job-setup-file"
cmd+=" -d $dataset_name"
cmd+=" -O $project_out_dir"
if [ ! -z $hap_window_sizes ]
then
    cmd+=" --hap-window $hap_window_sizes"
fi
if [ ! -z $input_bfile_prefix ]
then
    cmd+=" --bfile $input_bfile_prefix"
fi
if [ ! -z $input_file_prefix ]
then
    cmd+=" --file $input_file_prefix"
fi
cmd+=" --pheno $phenotype_file"
if [ ! -z $project_code ]
then
    cmd+=" -p $project_code"
fi
if [ ! -z $sample_info ]
then
    cmd+=" --sample_info $sample_info"
fi
if [ ! -z $cutoff_pvalue ]
then
    cmd+=" --cutoff_pvalue $cutoff_pvalue"
fi
if [ ! -z $cutoff_ors ]
then
    cmd+=" --cutoff_ors $cutoff_ors"
fi
if [ ! -z $input_dna_regions ]
then
    cmd+=" -R $input_dna_regions"
fi
if [ ! -z $filter_criteria ]
then
    cmd+=" --filter_criteria $filter_criteria"
fi
if [ ! -z $fam_hap_prefix ]
then
    cmd+=" --fam_hap $fam_hap_prefix"
fi
cmd+=" -o $jobs_setup_file"

eval "$cmd"
