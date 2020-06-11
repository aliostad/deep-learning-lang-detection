#!/bin/bash
source ./rrp-lib.sh
MODEL="setting"

function generate_scaffold () {
    rails generate scaffold ${MODEL} \
	name:string \
	email:string \
	phone:string \
	address:string \
	lat:float \
	long:float
}

function edit_model () {
    MODEL_RB="${TOP_DIR}/app/models/${MODEL}.rb"
    cat >> ${MODEL_RB} <<EOF
EOF

    $EDITOR ${MODEL_RB}

    echo "Don't forget to edit foreign key model, if applicable"
    
}

function do_migration () {
    rake db:migrate
}

###### Main program #######

generate_scaffold
edit_model
do_migration
