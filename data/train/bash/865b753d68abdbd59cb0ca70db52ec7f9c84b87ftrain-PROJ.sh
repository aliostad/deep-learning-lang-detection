#!/bin/bash

cd /export/a04/jguo/work/parser/clnndep

if [ $# -ne 1 ]; then
    echo "Usage: ./train.sh [cls|0,1]"
    exit -1
fi

# lang=${lang}
cls=$1
corpus=udt/en/
models=models/

f_train=$corpus/en-universal-train-brown.conll
f_dev=$corpus/en-universal-dev-brown.conll

if [ "$cls" = "1" ]; then
    echo "Train PROJ+Cluster"
    model_dir=$models/model.proj.cls
    f_conf=conf/proj-dvc.cfg
else
    echo "Train PROJ"
    model_dir=$models/model.proj
    f_conf=conf/proj-dv.cfg
fi

if [ ! -d $model_dir ]; then
    mkdir $model_dir
fi
f_model=$model_dir/model

./bin/clnndep -train $f_train \
              -dev $f_dev     \
              -model $f_model \
              -cfg $f_conf    \
              -emb resources/projected/en.50

