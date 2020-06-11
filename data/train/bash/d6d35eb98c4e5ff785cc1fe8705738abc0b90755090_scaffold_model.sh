#!/bin/bash
source ./rrp-lib.sh

MODEL='model'

function generate_scaffold () {
    rails generate scaffold ${MODEL} \
	user_id:integer \
	make_id:integer \
	name:string \
	image_url:string \
	wikipedia:string \
	url:string
}

function edit_model () {
    MODEL_RB="${TOP_DIR}/app/models/${MODEL}.rb"
    cat >> ${MODEL_RB} <<EOF
  validates :user_id, :presence => true, :numericality => true
  validates :name, :presence => true
  belongs_to :make
EOF

    $EDITOR ${MODEL_RB}
    echo "Don't forget to edit foreign key model, if applicable"
}

###### Main program #######
generate_scaffold
edit_model
read -p "Run db:migrate? " && rake db:migrate
