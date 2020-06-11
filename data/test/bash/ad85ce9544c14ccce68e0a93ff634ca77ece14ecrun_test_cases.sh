#!/bin/bash

function checkProcess() {
    local exitStatus=$1;
    local testCase=$2;
    if [ $exitStatus -ne 0 ]; then
        echo "Failed with return code $exitStatus on test: $testCase";
        exit 1;
    fi
}

make clean
checkProcess $? "make clean"
make -j
checkProcess $? "make -j"
./rmtest_create_tables
checkProcess $? "rmtest_create_tables"
./rmtest_00
checkProcess $? "rmtest_00"
./rmtest_01
checkProcess $? "rmtest_01"
./rmtest_02
checkProcess $? "rmtest_02"
./rmtest_03
checkProcess $? "rmtest_03"
./rmtest_04
checkProcess $? "rmtest_04"
./rmtest_05
checkProcess $? "rmtest_05"
./rmtest_06
checkProcess $? "rmtest_06"
./rmtest_07
checkProcess $? "rmtest_07"
./rmtest_08a
checkProcess $? "rmtest_08a"
./rmtest_08b
checkProcess $? "rmtest_08b"
./rmtest_09
checkProcess $? "rmtest_09"
./rmtest_10
checkProcess $? "rmtest_10"
./rmtest_11
checkProcess $? "rmtest_11"
./rmtest_12
checkProcess $? "rmtest_12"
./rmtest_13
checkProcess $? "rmtest_13"
./rmtest_14
checkProcess $? "rmtest_14"
#valgrind --leak-check=full ./rmtest_15
./rmtest_15
checkProcess $? "rmtest_15"
./rmtest_16
checkProcess $? "rmtest_16"
