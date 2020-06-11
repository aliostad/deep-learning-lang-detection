#!/bin/bash
if [ $# -lt 2 ]; then
    echo "ERROR: wrong number of input arguments.";
    exit 1;
fi

if [ ! -d $1 ]; then
    echo "ERROR: first argument should be a path to the model."
    exit 1;
fi

if [ ! -f $1/model.weight.$2.tgz ]; then
    echo "ERROR: $1/model.weight.$2.tgz is not a model file.";
    exit 1;
fi

if [ ! -f $1/model.word.$2.tgz ]; then
    echo "ERROR: $1/model.word.$2.tgz is not a model file.";
    exit 1;
fi


echo "move weight"
mv $1/model.weight.$2.tgz $1/tmp.weight.tgz

echo "move word"
mv $1/model.word.$2.tgz $1/tmp.word.tgz

echo "remove model"
rm $1/model.w*

echo "restore file"
mv $1/tmp.weight.tgz $1/model.weight.$2.tgz
mv $1/tmp.word.tgz $1/model.word.$2.tgz
