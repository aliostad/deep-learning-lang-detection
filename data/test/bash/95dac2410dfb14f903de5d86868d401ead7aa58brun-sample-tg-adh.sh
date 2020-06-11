#!/bin/csh

# This script runs BOXER on a small sample

source set.sh

#set d=${main}/src/sample-data
set d=${main}/boxer-bayesian-regression/sample-data

set a=train:${d}/train-set.xml 
set a1=test:${d}/train-set.xml:${out}/sample-aa-scores-tg.txt 
set b=test:${d}/test-set.xml:${out}/sample-ab-scores-tg.txt 

#    read-learner:$d/tg-learner-param.xml \

time java $opt -Dmodel=tg $driver \
    $a \
    train:${d}/train-set-2.xml  \
    $a1    $b \
    write-suite:${out}/sample-suite-out-x.xml write:${out}/sample-model-x.xml


