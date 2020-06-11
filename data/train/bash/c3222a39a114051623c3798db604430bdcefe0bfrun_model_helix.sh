#!/bin/sh

#
# Run a given model, and save output to given location
#


BASEDIR=/home/gene245/cprobert/deep-psp/keras/
OUTPUT_DIR=${BASEDIR}output/

MODEL=$1
OUTPUT=${OUTPUT_DIR}${2}
NUMEXS=$3
NUMEPOCHS=$4
TASKSET=$5

echo ">>running model ${MODEL}"
echo ">>writing model output to ${OUTPUT}"
echo ">>using ${NUMEXS} examples"
echo ">>using ${NUMEPOCHS} epochs"
echo ">>using taskset: ${TASKSET}"
echo ">>using task: helix"

taskset -c ${TASKSET} \
	python ${BASEDIR}train_model.py --model $MODEL --numexs $NUMEXS \
		--outputName $OUTPUT --numepochs $NUMEPOCHS \
		--bkgrd feature --task helix > ${OUTPUT}_log.txt

echo ">>Finished running model"
