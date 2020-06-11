#! /usr/bin/env bash

for model in $(ls models); do
    echo "verifing model $model"
    caffe time -model models/$model/train_val.prototxt -iterations 1 > /dev/null 2>&1
    if [ $? != 0 ]; then
        echo "model $model failed:";
        caffe time -model models/$model/train_val.prototxt -iterations 1;
        exit 1;
    fi

    caffe time -model models/$model/deploy.prototxt -iterations 1 > /dev/null 2>&1

    if [ $? != 0 ]; then
        echo "model $model failed:";
        caffe time -model models/$model/deploy.prototxt -iterations 1;
        exit 1;
    fi
done
