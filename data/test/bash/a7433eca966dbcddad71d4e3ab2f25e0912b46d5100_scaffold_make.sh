#!/bin/bash
source ./rrp-lib.sh

MODEL='make'

function generate_scaffold () {
    rails generate scaffold ${MODEL} \
	user_id:integer \
	name:string \
	url:string
}

function edit_model () {
    MODEL_RB="${TOP_DIR}/app/models/${MODEL}.rb"
    cat >> ${MODEL_RB} <<EOF
  validates :user_id, :presence => true, :numericality => true
  validates :name, :presence => true, :uniqueness => true
  has_many :models
EOF

    $EDITOR ${MODEL_RB}
}

###### Main program #######

generate_scaffold
edit_model
read -p "Run rake db:migrate? " && rake db:migrate
