#!/bin/bash
source ./rrp-lib.sh

MODEL="link"

function generate_scaffold () {
    rails generate scaffold ${MODEL} name:string \
	name:string \
	description:string \
	url:string \
	wikipedia:string
}

function edit_model () {
    MODEL_RB="${TOP_DIR}/app/models/${MODEL}.rb"
    cat >> ${MODEL_RB} <<EOF
validates_presence_of :name
validates_uniqueness_of :name
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
