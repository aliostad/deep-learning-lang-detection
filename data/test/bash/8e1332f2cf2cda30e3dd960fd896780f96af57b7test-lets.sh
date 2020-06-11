#!/bin/bash

. $TESTS/functions.sh

test_compile let-string-process \
"channel a
channel b

P = let
      string(0,     _)     = STOP
      string(count, event) = event -> string(count-1, event)
      A = string(5,a)
      B = string(5,b)
    within
      A ||| B" \
"P" \
"process P;
event a;
process P.string.1;
process P.string.2;
process P.string.3;
process P.string.4;
process P.string.5;
prefix P.string.5 = a -> STOP;
prefix P.string.4 = a -> P.string.5;
prefix P.string.3 = a -> P.string.4;
prefix P.string.2 = a -> P.string.3;
prefix P.string.1 = a -> P.string.2;
event b;
process P.string.7;
process P.string.8;
process P.string.9;
process P.string.10;
process P.string.11;
prefix P.string.11 = b -> STOP;
prefix P.string.10 = b -> P.string.11;
prefix P.string.9 = b -> P.string.10;
prefix P.string.8 = b -> P.string.9;
prefix P.string.7 = b -> P.string.8;
interleave P = P.string.1 ||| P.string.7;"

test_script_expression let-fib-map \
"x = let
      f(0) = 1
      f(1) = 1
      f(x) = f(x-2) + f(x-1)
      map(f,<>) = <>
      map(f,<x>^xs) = <f(x)> ^ map(f,xs)
    within
      map(f, <0,1,2,3,4,5,6,7,8,9,10>)" \
"x" \
"<1,1,2,3,5,8,13,21,34,55,89>"

test_script_expression let-pattern-01 \
"x = let
      <x>^y = <1,2,3>
    within
      y ^ <x>" \
"x" \
"<2,3,1>"
