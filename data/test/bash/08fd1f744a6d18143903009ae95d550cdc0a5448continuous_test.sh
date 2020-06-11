#!/bin/bash -eu
runs=0
CHUNK=5
NUM=40

function num_alive() {
    ps aux | grep -v grep | grep "ython test_client.py" | wc -l | awk '{ print $1 }'
}

function num_errors() {
    grep ERROR /tmp/uuss.dev.log | wc -l | awk '{ print $1 }'
}

while true; do
    for (( j = 0; j < $CHUNK; j++)); do
        PYTHONPATH=../../../.. python test_client.py &
    done >> /tmp/uuss_test.log 2>&1
    runs=$(echo "$runs + $CHUNK" | bc)
    echo -ne "\r                                                                              \r$runs runs started, "$(num_alive)" running, "$(num_errors)" errors"
    while [ $(num_alive) -ge $NUM ]; do
        echo -ne "\r                                                                              \r$runs runs started, "$(num_alive)" running, "$(num_errors)" errors"
        sleep 1
    done
done
