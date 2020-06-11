#!/usr/bin/env bash

SINGLE_OR_ENSEMBLE=$1

if [ "$SINGLE_OR_ENSEMBLE" = "single" ]; then
    python3 tools/bioasq_inference_server.py \
        --list_answer_prob_threshold 0.02 \
        --model_config /model/fold_1/config.pickle \
        --beam_size 20 --batch_size 16
else
    python3 tools/bioasq_inference_server.py \
        --list_answer_prob_threshold 0.02 \
        --model_config /model/fold_0/config.pickle,/model/fold_1/config.pickle,/model/fold_2/config.pickle,/model/fold_3/config.pickle,/model/fold_4/config.pickle \
        --beam_size 20 --batch_size 16
fi
