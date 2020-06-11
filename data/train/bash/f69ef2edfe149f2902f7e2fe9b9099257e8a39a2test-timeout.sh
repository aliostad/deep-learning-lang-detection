#!/bin/bash

. $TESTS/functions.sh

test_compile timeout-01 "
channel a
channel b

P = a -> P [> b -> P" "P" "process P;
event a;
process P.0;
prefix P.0 = a -> P;
event b;
process P.1;
prefix P.1 = b -> P;
timeout P = P.0 [> P.1;"

test_compile timeout-02 "
channel a
channel b
channel c

P = a -> P [> b -> P [> c -> P" "P" "process P;
process P.0;
event a;
process P.1;
prefix P.1 = a -> P;
event b;
process P.2;
prefix P.2 = b -> P;
timeout P.0 = P.1 [> P.2;
event c;
process P.3;
prefix P.3 = c -> P;
timeout P = P.0 [> P.3;"
