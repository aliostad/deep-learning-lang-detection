#!/bin/bash

project_home=$(readlink -f $(dirname $0))/..
modelpath=$project_home/models
model_dir=${modelpath}/lda-0.5-0.1-100-100/

srcpath=$project_home/src

python ${srcpath}/com-word-analysis.py $model_dir/train_data > $model_dir/word-com

sort -n -k1 $model_dir/word-com > $model_dir/word-com-sort

cat $model_dir/word-com-sort | python ${srcpath}/word-com.py > $model_dir/word-feature

sort -nr -k4 $model_dir/word-feature > $model_dir/word-feature-sort





#mv $purchase_history-sort-* ${datapath}/id_data
