#!/bin/csh

# This script runs BOXER on a small sample

source set.sh

#set d=${main}/src/sample-data
set d=${main}/boxer-bayesian-regression/sample-data

set a=train:${d}/train-set.xml 
set a1=test:${d}/train-set.xml:${out}/sample-aa-scores-tg.txt 
set b=test:${d}/test-set.xml:${out}/sample-aa-scores-tg.txt 

time java $opt -Dmodel=eg $driver \
    $a $a1    $b \
    write-suite:${out}/sample-suite-out.xml write:${out}/sample-model.xml

#    delete-discr:Climate \
#    write-suite:${out}/sample-suite-out-2.xml write:${out}/sample-model-2.xml \
#    $b


