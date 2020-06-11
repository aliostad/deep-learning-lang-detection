#!/bin/bash

# Script to validate the entire ip space for two erl_ip_index implementations
# Parameters are directories.

OLD_IMPL="$1"
NEW_IMPL="$2"

CHUNK_SIZE=$((2**19))

while true; do
    SEED1=$RANDOM
    SEED2=$RANDOM
    SEED3=$RANDOM
    printf "Running random run of 0x%x with seeds %d %d %d\n" $CHUNK_SIZE $SEED1 $SEED2 $SEED3
    COMMAND="erl -pa ebin -noshell -run erl_ip_index_debug test_random_results iplists_validate.bert blacklisted-ip-ranges.csv results $CHUNK_SIZE $SEED1 $SEED2 $SEED3 -run init stop"
    (cd $OLD_IMPL; $COMMAND) &
    (cd $NEW_IMPL; $COMMAND) &
    wait
    diff $OLD_IMPL/results $NEW_IMPL/results > /dev/null
    if [ $? -ne 0 ]; then
        printf "Results differ, aborting\n" $CURRENT $FINISH
        exit 1
    fi
done
