#!/bin/sh
#usage: ./prep_data.sh target_folder

process_problem(){
    echo $1 $2 $3
    mkdir -p $1/$2/$3/results
    mkdir -p $1/$2/$3/models
    python3.3 prep_data.py --data $2 --target $3 --dump-dir $1/$2/$3 --batch-based-cv
}

process_problem_sep_2014(){
    echo $1 $2
    python3.3 prep_data.py --data $2 --dump-dir $1
}

#process_problem $1 vantveer prognosis

#process_problem $1 nordlund TvsB
#process_problem $1 nordlund HeHvst1221


#process_problem $1 TCGA-LAML vital_status
#process_problem $1 TCGA-LAML risk_group

#process_problem $1 TCGA-LAML-GeneExpression vital_status
#process_problem $1 TCGA-LAML-GeneExpression risk_group


# for batch based cv:
#process_problem_sep_2014 $1 TCGA-BRCA
#process_problem_sep_2014 $1 TCGA-UCEC
#process_problem_sep_2014 $1 TCGA-THCA
#process_problem_sep_2014 $1 TCGA-SARC
#process_problem_sep_2014 $1 TCGA-LGG
process_problem_sep_2014 $1 TCGA-COAD
process_problem_sep_2014 $1 TCGA-KIRC
process_problem_sep_2014 $1 TCGA-LIHC
