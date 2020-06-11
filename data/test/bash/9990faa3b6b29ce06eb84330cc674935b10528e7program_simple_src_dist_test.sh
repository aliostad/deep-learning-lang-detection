#!/bin/sh

. ./testlib.sh

set -e
cd program_simple
invoke_make clean

#  first clean make
invoke_make src-dist
    assert_exists aaa-1.2.3-1.tar.gz

invoke_test tar tzf aaa-1.2.3-1.tar.gz
    assert_grep aaa-1.2.3-1/b.c stdout
    assert_grep aaa-1.2.3-1/a.cpp stdout
    assert_grep aaa-1.2.3-1/Makefile stdout
    assert_grep aaa-1.2.3-1/makefoo/main.mk stdout
    

exit 0

./aaa-1.2.3-1/
./aaa-1.2.3-1/b.c
./aaa-1.2.3-1/a.cpp
./aaa-1.2.3-1/Makefile
./aaa-1.2.3-1/makefoo/
./aaa-1.2.3-1/makefoo/autoconf_helpers/
./aaa-1.2.3-1/makefoo/autoconf_helpers/config.guess
./aaa-1.2.3-1/makefoo/configure.sh
./aaa-1.2.3-1/makefoo/native.mk
./aaa-1.2.3-1/makefoo/src-dist.mk
./aaa-1.2.3-1/makefoo/main.mk
./aaa-1.2.3-1/makefoo/src-dist.post.mk
./aaa-1.2.3-1/makefoo/defs.mk
    
