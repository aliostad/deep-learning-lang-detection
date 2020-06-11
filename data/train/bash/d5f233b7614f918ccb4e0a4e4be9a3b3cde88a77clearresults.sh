#!/bin/bash
#usage: ./clearresults.sh target_folder

DATA_ROOT="`pwd`/../../Data/"

process_problem(){
    echo $1 $2 $3
    #rm  $1/$2/$3/results/*rat*
    #rm  $1/$2/$3/results/*raccoon*
    #rm  $1/$2/$3/results/*others*
    #rm  $1/$2/$3/models/*others*
    rm  $DATA_ROOT/$1/$2/results/*$3*
}

#process_problem $1 vantveer prognosis

#process_problem $1 nordlund TvsB
#process_problem $1 nordlund HeHvst1221

#process_problem $1 TCGA-LAML vital_status
#process_problem $1 TCGA-LAML risk_group

#process_problem $1 TCGA-LAML-GeneExpression vital_status
#process_problem $1 TCGA-LAML-GeneExpression risk_group

process_problem TCGA-BRCA er_status_by_ihc $1
process_problem TCGA-BRCA ajcc_pathologic_tumor_stage $1
process_problem TCGA-BRCA ajcc_tumor_pathologic_pt $1
process_problem TCGA-BRCA ajcc_nodes_pathologic_pn $1

process_problem TCGA-SARC residual_tumor $1
process_problem TCGA-SARC vital_status $1
process_problem TCGA-SARC tumor_status $1

process_problem TCGA-THCA tumor_focality $1
process_problem TCGA-THCA ajcc_pathologic_tumor_stage $1

process_problem TCGA-UCEC tumor_status $1
process_problem TCGA-UCEC vital_status $1
process_problem TCGA-UCEC retrospective_collection $1

process_problem TCGA-LGG vital_status $1
process_problem TCGA-LGG tumor_status $1
process_problem TCGA-LGG histologic_diagnosis $1
process_problem TCGA-LGG tumor_grade $1

process_problem TCGA-COAD ajcc_pathologic_tumor_stage $1
process_problem TCGA-COAD ajcc_tumor_pathologic_pt $1
process_problem TCGA-COAD ajcc_nodes_pathologic_pn $1

process_problem TCGA-KIRC ajcc_pathologic_tumor_stage $1
process_problem TCGA-KIRC ajcc_tumor_pathologic_pt $1
process_problem TCGA-KIRC ajcc_nodes_pathologic_pn $1
process_problem TCGA-KIRC vital_status $1

process_problem TCGA-LIHC ajcc_pathologic_tumor_stage $1
process_problem TCGA-LIHC ajcc_tumor_pathologic_pt $1
process_problem TCGA-LIHC ajcc_nodes_pathologic_pn $1
process_problem TCGA-LIHC vital_status $1
process_problem TCGA-LIHC tumor_grade $1

process_problem ICGC-LYMPH-DE foll_dlbcl $1

