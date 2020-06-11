#!/bin/bash

SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
PROJECT_DIR=$(dirname $( dirname $SCRIPT_DIR ))

source $PROJECT_DIR/scripts/utils.sh

STACK_SIZE=1
PATIENCE=100
echo "Commencing Grid Search"
echo "* running on ${NUM_THREADS} cores"
VECTOR_FILE="${PROJECT_DIR}/data/glove/glove.6B.300d.txt"
PROGRAM="${PROJECT_DIR}/build/examples/sparse_paraphrase"

if [ "$#" -ne 1 ]; then
    echo "usage: $0 [results_dir] "
    exit
fi

if [ ! -d "$1" ]; then
    echo "Could not find directory \"$1\""
    exit
fi

SAVE_FOLDER="$(ensure_dir $1)saved_models"
RESULTS_FILE="$(ensure_dir $1)results.txt"
BASE_FLAGS="--results_file=${RESULTS_FILE}"
BASE_FLAGS="${BASE_FLAGS} --min_occurence 3 --nouse_characters --negative_samples 3"
BASE_FLAGS="${BASE_FLAGS} --stack_size=${STACK_SIZE} --patience=${PATIENCE}"
BASE_FLAGS="${BASE_FLAGS} --epochs=2000 -j=1"
# use some pretrained vectors:
# BASE_FLAGS="${BASE_FLAGS} --pretrained_vectors=${VECTOR_FILE}"
echo "* saving results to ${RESULTS_FILE}"

# start out clean
if [ -f $RESULTS_FILE ]; then
    rm $RESULTS_FILE
fi

# create the results file
touch $RESULTS_FILE

# build the save folder
if [ ! -d "$SAVE_FOLDER" ]; then
    mkdir $SAVE_FOLDER
fi

for hidden in 50 150
do
    for dropout in 0.3
    do
        for reg in 0
        do
            for lr in 0.01
            do

                SAVE_LOCATION="${SAVE_FOLDER}/model_${hidden}_0"
                # previously saved models are no longer useful for this grid tile
                if [ ! -d $SAVE_LOCATION ]; then
                    mkdir $SAVE_LOCATION
                fi
                rm -rf "${SAVE_LOCATION}/*"
                $PROGRAM $BASE_FLAGS --dropout $dropout --save_location $SAVE_LOCATION  --memory_penalty 0.0 --learning_rate $lr --hidden $hidden --minibatch 100 --solver adagrad --reg $reg &
                pwait $NUM_THREADS

                # for penalty in 0.00001 0.0001 0.0005 0.001 0.01 0.1
                # do
                #     for curve in flat linear square
                #     do
                #         SAVE_LOCATION="${SAVE_FOLDER}/model${curve}_${penalty}"
                #         # previously saved models are no longer useful for this grid tile
                #         if [ ! -d $SAVE_LOCATION ]; then
                #             mkdir $SAVE_LOCATION
                #         fi
                #         rm -rf "${SAVE_LOCATION}/*"
                #         $PROGRAM $BASE_FLAGS --dropout $dropout --save_location $SAVE_LOCATION --memory_penalty_curve $curve --memory_penalty $penalty --learning_rate $lr --hidden $hidden --minibatch 100 --solver adagrad --reg $reg &
                #         pwait $NUM_THREADS
                #     done
                # done
            done
        done
    done
done
wait
