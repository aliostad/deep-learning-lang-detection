#!/bin/bash

# verbose
set -x


infile="./models/TreeTLSTM_pair_wvecDim_30_memDim_30_step_5e-2_epochs_15_rho_1e-5_droproot.bin"
model="TreeTLSTM" # the neural network type

label="pair"

echo $infile

# test the model on test data
python runNNet.py --inFile $infile --test --data "test" --model $model --label $label

# test the model on dev data
python runNNet.py --inFile $infile --test --data "dev" --model $model --label $label

# test the model on training data
#python runNNet.py --inFile $infile --test --data "train" --model $model

