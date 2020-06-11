#!/bin/bash

. $TESTS/functions.sh

test_compile aparallel-01 "
channel a
channel b

P = a -> STOP [{a} || {b}] b -> STOP" "P" \
"process P;
event a;
process P.0;
prefix P.0 = a -> STOP;
event b;
process P.1;
prefix P.1 = b -> STOP;
aparallel P = P.0 [{a}||{b}] P.1;"

test_compile aparallel-02 "
channel a
channel b
channel c

P = (a -> STOP [{a} || {b}] b -> STOP) [{a,b} || {c}] c -> STOP" "P" \
"process P;
process P.0;
event a;
process P.1;
prefix P.1 = a -> STOP;
event b;
process P.2;
prefix P.2 = b -> STOP;
aparallel P.0 = P.1 [{a}||{b}] P.2;
event c;
process P.3;
prefix P.3 = c -> STOP;
aparallel P = P.0 [{a,b}||{c}] P.3;"
