#!/bin/bash

# Written by Karolis Uziela in 2015

script_name=`basename $0`

if [ $# != 3 ] ; then
    echo_both "
Usage: 

$script_name [Parameters]

Parameters:
<target-file>
<model-file1>
<model-file2>

"
    exit 1
fi

target_file=$1
model_file=$2
model_file2=$3

TFILE="/tmp/pymol_align.$$.tmp"

#set dash_color,

target_base=`basename $target_file .pdb`
model_base=`basename $model_file .pdb`
model_base2=`basename $model_file2 .pdb`

echo "
load $target_file
load $model_file
load $model_file2
hide all
show cartoon
align $model_base, $target_base
align $model_base2, $target_base
center
" > $TFILE

pymol -u $TFILE

rm $TFILE
