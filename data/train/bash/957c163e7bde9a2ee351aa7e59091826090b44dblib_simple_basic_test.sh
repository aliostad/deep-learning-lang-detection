#!/bin/sh

. ./testlib.sh

set -e
cd lib_simple
invoke_make clean
invoke_make configure

#  first clean make
invoke_make
    assert_grep "compiling prog.cpp" stdout
    assert_grep "compiling lib.c" stdout
    assert_grep "creating static library (.*)libx" stdout
    assert_grep "linking program prog" stdout
    
    assert_exists liblibx.a
    assert_exists prog$EXECUTABLE_SUFFIX

# now remote program and check if it is relinked
sleep 1
echo "removed liblibx.a"
rm liblibx.a
invoke_make
    assert_exists prog$EXECUTABLE_SUFFIX
    assert_grepv "compiling" stdout
    assert_grep "creating static library (.*)libx" stdout
    assert_grep "linking program prog" stdout

# now remote program and check if it is relinked
sleep 1
echo "touched lib.c"
touch lib.c
invoke_make
    assert_exists prog$EXECUTABLE_SUFFIX
    assert_grep "compiling lib.c" stdout
    assert_grep "creating static library (.*)libx" stdout
    assert_grep "linking program prog" stdout

# now touch one file and check if
# only it is being recompiled
# and program is relinked

sleep 1
echo "touched prog.cpp"
touch prog.cpp

invoke_make 
    assert_grep "compiling prog.cpp" stdout
    assert_grepv "compiling lib.c" stdout
    assert_grep "linking program prog" stdout
    
    assert_exists prog$EXECUTABLE_SUFFIX

invoke_make clean


