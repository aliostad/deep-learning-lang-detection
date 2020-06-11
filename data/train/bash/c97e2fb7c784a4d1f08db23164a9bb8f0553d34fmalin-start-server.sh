#!/bin/bash

SALDO_MODEL=$SB_MODELS/saldo.pickle
MODEL_1700="$SB_MODELS/dalin.pickle $SB_MODELS/swedberg.pickle"
SALDO_COMPOUND_MODEL=$SB_MODELS/saldo.compound.pickle

MALT_JAR=/export/res/lb/korpus/tools/annotate/bin/maltparser-1.7.1/maltparser-1.7.1.jar
MALT_MODEL=$SB_MODELS/swemalt-1.7.mco

PROCESSES=16
VERBOSE=true

PIPELINE_SOCK='/home/malin/pipe.sock'

rm -f $PIPELINE_SOCK
python catapult.py \
    --socket_path $PIPELINE_SOCK \
    --processes $PROCESSES \
    --saldo_model $SALDO_MODEL \
    --models_1700s "$MODEL_1700" \
    --compound_model $SALDO_COMPOUND_MODEL \
    --verbose $VERBOSE 

