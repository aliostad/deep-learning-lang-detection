#!/bin/bash

n=500
r=50

function execute-model {
    local model=$1
    local params=$2
    
    # Execute 30 repetitions of propagation model in a complete graph with 100 vertices
    bin/propagation --network K $n --repetition $r --outfile test/$model-clique.dat --propagation $model $params
    # Execute dynamic model with same parameters
    bin/dynamic $model $n $params test/$model-dynamic.dat
}

execute-model "SI"   "1.0"
execute-model "SIS"  "1.0 0.5"
execute-model "SIR"  "1.0 0.5"
execute-model "SEIR" "1.0 0.5 1.0"
execute-model "DK"   "1.0 0.5"

for model in SI SIS SIR SEIR DK
do
	scripts/validate_propagation.r $model &
done

