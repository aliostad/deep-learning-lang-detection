#!/bin/bash

export population=$1
export sequence_type=$2
mkdir -p data/breseq_output
for i in $(python population_parameters.py samples ${population} ${sequence_type}); do
    export sample_name=$i
    export params=$sample_name

    mkdir -p data/breseq_output/${sample_name}

    if [ ! -e "data/breseq_output/${sample_name}/output/evidence/evidence.gd" ]
    then

    rm -rf data/breseq_output/${sample_name}
    mkdir -p data/breseq_output/${sample_name}

    sbatch --job-name=breseq-${i} breseq_genomes.sbatch

    fi
done
