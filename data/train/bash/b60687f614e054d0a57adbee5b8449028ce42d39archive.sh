#!/bin/sh
# Usage: ./archive.sh <model path> <spearmint trial>
if [ $# -ne 2 ];
then
   echo "Usage: ./archive.sh <model path> <spearmint trial>";
   exit 1;
fi

MODEL=$1
TRIAL=$2
DATE=`date +%Y-%m-%d-%H-%M`

MODEL_FILES=$MODEL/output/spearmint.log

if [ ! -d "$MODEL/archive/" ];
then
   mkdir $MODEL/archive/;
fi

mkdir $MODEL/archive/$DATE/

# Archive model and files:
cp $MODEL_FILES $MODEL/archive/$DATE/
# Best Result:
echo "$TRIAL" > $MODEL/archive/$DATE/best.log

# Archive the full log:
#cp $MODEL/logs/caffe.INFO $MODEL/archive/$DATE/caffe.INFO

# Archive prototxt definitions and test/training lists:
#cp $MODEL/*txt $MODEL/archive/$DATE/
# Record early stopping iteration:
#echo "$ITER" > $MODEL/archive/$DATE/early_stopping.log

echo "Archived with $DATE timestamp"
