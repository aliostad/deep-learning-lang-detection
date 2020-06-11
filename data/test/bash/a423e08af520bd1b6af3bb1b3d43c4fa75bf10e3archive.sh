#!/bin/sh
# Usage: ./archive.sh <model path> <iteration>
if [ $# -ne 2 ];
then
   echo "Usage: ./archive.sh <model path> <iteration number>";
   exit 1;
fi

MODEL=$1
ITER=$2
DATE=`date +%Y-%m-%d-%T`

MODEL_FILES=$MODEL/train/_iter_*.caffemodel
SOLVER_FILES=$MODEL/train/_iter_*.solverstate

if [ ! -d "$MODEL/archive/" ];
then
   mkdir $MODEL/archive/;
fi

mkdir $MODEL/archive/$DATE/

# Archive model and solverstate files:
cp $MODEL_FILES $MODEL/archive/$DATE/
cp $SOLVER_FILES $MODEL/archive/$DATE/

# Archive the full log:
cp $MODEL/logs/caffe.INFO $MODEL/archive/$DATE/caffe.INFO

# Archive prototxt definitions and test/training lists:
cp $MODEL/*txt $MODEL/archive/$DATE/
# Record early stopping iteration:
echo "$ITER" > $MODEL/archive/$DATE/early_stopping.log

echo "Archived with $DATE timestamp"
