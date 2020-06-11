#!/usr/bin/env bash

#
# Add a bigram language model to the phone loop.
#

if [ $# -ne 4 ]; then
    echo "usage: $0 <setup.sh> <model_dir> <lm_dir> <out_dir>"
    exit 1
fi

setup=$1
model=$2/model.bin
lm=$3/lm.bin
out_dir=$4

source $setup || exit 1

if [ ! -e "$out_dir/.done" ]; then
    mkdir -p "$out_dir"
    # Add the language model to the phone loop
    amdtk_ploop_set_lm "$model" \
        "$lm" "$out_dir"/model.bin
    date > "$out_dir/.done"
else
    echo "The model has already been created. Skipping."
fi
