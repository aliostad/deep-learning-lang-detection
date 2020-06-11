#!/bin/bash
source ./rrp-lib.sh
MODEL="**edit_me**"

function generate_scaffold () {
    rails generate scaffold ${MODEL} name:string \
	username:string \
	password:string \
	email:string
}

function edit_model () {
    MODEL_RB="${TOP_DIR}/app/models/${MODEL}.rb"
    cat >> ${MODEL_RB} <<EOF

# validates_presence_of :name
# validates_presence_of :username
# validates_uniqueness_of :username
# validates_presence_of :password
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
