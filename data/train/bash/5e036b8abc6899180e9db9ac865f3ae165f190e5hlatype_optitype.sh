#!/bin/bash

repeat_arg()
{
    arg=$1
    shift
    set -x

    for x in $*; do
        echo $arg $x
    done
}

run_optitype()
{
    sample=$1
    set -x
    cubi-optitype \
        --create-output-dir \
        --output-dir ../analysis/${sample}/hla_typing/optitype \
        --output-prefix ${sample} \
        --log-dir ../analysis/${sample}/hla_typing/optitype/log \
        --mapping-threads 28 \
        $(repeat_arg --reads       ../samples/${sample}/fastq/original/*_R1_*.fastq.gz) \
        $(repeat_arg --right-reads ../samples/${sample}/fastq/original/*_R2_*.fastq.gz)
}
export -f repeat_arg
export -f run_optitype

#for sample in BIH-002; do run_optitype ${sample}; done
#for sample in CELL_ID_6 CELL_ID_13 CELL_ID_16; do run_optitype ${sample}; done
for sample in CELL_ID_16; do run_optitype ${sample}; done
#parallel -j 2 -v 'run_optitype {}' ::: BIH-002 BIH-004 BIH-016 BIH-021
