#!/bin/sh

. ./testlib.sh

type cl || skip_test "cl.exe (MSVS compiler) required for this test case"

set -e
cd program_simple
invoke_make clean
invoke_make configure TOOLSET=msvs

#  first clean make
invoke_make
    assert_grep "compiling a.cpp" stdout
    assert_grep "compiling b.c" stdout
    assert_grep "linking program program_simple" stdout
    
    assert_exists .obj/a.prog.obj .obj/b.prog.obj program_simple$EXECUTABLE_SUFFIX

# now remote program and check if it is relinked
sleep 1
rm program_simple$EXECUTABLE_SUFFIX
echo "removed executable, shall relink"

invoke_make
    assert_exists program_simple$EXECUTABLE_SUFFIX
    assert_grepv "compiling" stdout
    assert_grep "linking program program_simple" stdout

# now touch one file and check if
# only it is being recompiled
# and program is relinked
sleep 1
touch a.cpp
echo "touched a.cpp, shall recompile&relink"

invoke_make 
    assert_grep "compiling a.cpp" stdout
    assert_grepv "compiling a.c" stdout
    assert_grep "linking program program_simple" stdout
    
    assert_exists .obj/a.prog.obj .obj/b.prog.obj program_simple$EXECUTABLE_SUFFIX

invoke_make clean
