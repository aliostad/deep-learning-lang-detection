#!/bin/bash

if [[ $# -eq 0 || $# -ne 1 ]]
then
    echo ""
    echo "To run the flattening, invoke as: "
    echo "  "$0" <mod file name>"
    echo ""
    exit 1;
fi

arg=$1

echo "Running in:"
pwd
if [ ! -f "$arg" ]
then
  echo "<><><> Error: No such model file as ""$arg"
  exit 1;
fi

CONVERTER_HOME=/home/ali/coconut-converters

# Keep in sync with paths.py
AMPL=ampl

export AMPL
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CONVERTER_HOME 
export CONVERTER_HOME

echo "AMPL config file location"
echo $OPTIONS_IN

AMPL2DAG="$CONVERTER_HOME/ampl2dag" 

model_file=$arg
model_path=$(dirname $model_file)
model_file=$(basename $model_file)
model_name=${model_file%.*}

# Keep these extensions in sync with clean_coconut.py
rm -f $model_name.col $model_name.row $model_name.nl $model_name.sol $model_name.dag

$AMPL2DAG $model_file

if [ $? -ne 0 ]; then
  #if [ -f $model_name.tmp ] 
  #  then rm $model_name.tmp 
  #fi
  exit 1;
fi
