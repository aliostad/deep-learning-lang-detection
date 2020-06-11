#!/bin/bash

echo building...

DSLDI_LIB_HOME=/home/rlindeman/Documents/TU/strategoxt/git-stuff/dsldi
#STRJFLAGS=--library --verbose 3 -clean -O 3 -I $(DSLDI_LIB_HOME)
INCLUDES="-I $DSLDI_LIB_HOME"
#STRJFLAGS="--library --verbose 3 -clean -O 0 -k 3"
STRJFLAGS="-clean -O 1 --library -p foo"

strj --version
strj -i optimize-me.str -o build/java/Main.java $INCLUDES $STRJFLAGS

# -O 0 # no optimizations
# -O 2 # kills some debug-events
# -O 3 #

grep -ir "r-enter" --include=*.str . | wc -l | xargs echo r-enter :
grep -ir "r-exit" --include=*.str . | wc -l  | xargs echo r-exit  :
grep -ir "s-enter" --include=*.str . | wc -l | xargs echo s-enter :
grep -ir "s-exit" --include=*.str . | wc -l  | xargs echo s-exit  :
grep -ir "s-step" --include=*.str . | wc -l  | xargs echo s-step  :

grep -ir "r_enter_0_3.instance.invoke" --include=*.java . | wc -l | xargs echo r_enter_0_3 :
grep -ir "r_exit_0_3.instance.invoke" --include=*.java . | wc -l  | xargs echo r_exit_0_3  :
grep -ir "s_enter_0_3.instance.invoke" --include=*.java . | wc -l | xargs echo s_enter_0_3 :
grep -ir "s_exit_0_3.instance.invoke" --include=*.java . | wc -l  | xargs echo s_exit_0_3  :
grep -ir "s_step_0_2.instance.invoke" --include=*.java . | wc -l  | xargs echo s_step_0_2  :

