#!/bin/sh

. ./testlib.sh

set -e
cd program_simple
invoke_make clean
invoke_make configure

#  first clean make
invoke_make
    assert_grep "compiling a.cpp" stdout
    assert_grep "compiling b.c" stdout
    assert_grep "linking program program_simple" stdout
    
    assert_exists .obj/a.prog.o .obj/b.prog.o program_simple$EXECUTABLE_SUFFIX

# now remote program and check if it is relinked
rm program_simple$EXECUTABLE_SUFFIX
invoke_make
    assert_exists program_simple$EXECUTABLE_SUFFIX
    assert_grepv "compiling" stdout
    assert_grep "linking program program_simple" stdout

# now touch one file and check if
# only it is being recompiled
# and program is relinked
sleep_hack
touch a.cpp
rm program_simple$EXECUTABLE_SUFFIX


invoke_make 
    assert_grep "compiling a.cpp" stdout
    assert_grepv "compiling a.c" stdout
    assert_grep "linking program program_simple" stdout
    
    assert_exists .obj/a.prog.o .obj/b.prog.o program_simple$EXECUTABLE_SUFFIX

invoke_make clean


