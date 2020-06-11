#!/bin/bash

project_home=$(readlink -f $(dirname $0))/..
modelpath=$project_home/models
model_dir=${modelpath}/lda-0.5-0.1-100-100/

srcpath=$project_home/src

model_name=model-final

python ${srcpath}/doc-topic-com.py $model_dir/$model_name.theta $model_dir/train_data > $model_dir/doc-topic-com

sort -n -k1 $model_dir/doc-topic-com > $model_dir/doc-topic-com-sort

cat $model_dir/doc-topic-com-sort | python ${srcpath}/topic-com.py > $model_dir/topic-com

sort -nr -k4 $model_dir/topic-com > $model_dir/topic-com-sort





#mv $purchase_history-sort-* ${datapath}/id_data
