#!/bin/bash

. $TESTS/functions.sh

test_compile newlines-01 "
channel a
channel b

P = let
      As = \\
        x
        @
        if
          (
           x
             ==
           0
          )
        then
          STOP
        else
          a
            ->
          As(
             x -
             1
            )
      Bs = \x @ if (x == 0) then STOP else b -> Bs(x-1)
    within
      As(5)
        |||
      Bs(5)
" "P" \
"process P;
event a;
process P.As.1;
process P.As.2;
process P.As.3;
process P.As.4;
process P.As.5;
prefix P.As.5 = a -> STOP;
prefix P.As.4 = a -> P.As.5;
prefix P.As.3 = a -> P.As.4;
prefix P.As.2 = a -> P.As.3;
prefix P.As.1 = a -> P.As.2;
event b;
process P.Bs.7;
process P.Bs.8;
process P.Bs.9;
process P.Bs.10;
process P.Bs.11;
prefix P.Bs.11 = b -> STOP;
prefix P.Bs.10 = b -> P.Bs.11;
prefix P.Bs.9 = b -> P.Bs.10;
prefix P.Bs.8 = b -> P.Bs.9;
prefix P.Bs.7 = b -> P.Bs.8;
interleave P = P.As.1 ||| P.Bs.7;"

test_script_expression newlines-02 "
P = 1
     +
    2
     *
    3
     /
    4 -
    5
" "P" -3
