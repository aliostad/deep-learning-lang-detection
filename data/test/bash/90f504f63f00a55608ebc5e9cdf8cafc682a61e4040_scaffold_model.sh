#!/bin/bash
source ./rrp-lib.sh

MODEL='model'


#	wikipedia:string \
#	url:string
function generate_scaffold () {
    rails generate scaffold ${MODEL} \
	make_id:integer \
	name:string
}

function edit_model () {
    MODEL_RB="${TOP_DIR}/app/models/${MODEL}.rb"
    cat >> ${MODEL_RB} <<EOF
  validates_presence_of :name
  belongs_to :make
EOF

    $EDITOR ${MODEL_RB}

    echo "Don't forget to edit foreign key model, if applicable"
    
}

function do_migration () {
    echo "Run db:migrate?"
    rake db:migrate
}

###### Main program #######

generate_scaffold
edit_model
do_migration
