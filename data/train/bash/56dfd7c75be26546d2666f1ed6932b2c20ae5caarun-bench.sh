#!/bin/bash

FILE="temp"
ENCFILE="temp_enc"
DECFILE="temp_dec"

BINARY="./process"

FILE_SIZES=(1 5)
CHUNK_SIZES=(1 2 4 7 13)
LIB_NAMES=("botan" "libgcrypt" "cryptopp")

TEST_CMDS[0]="(time %s) 2>&1 | grep real | cut -f 2" # time to run
TEST_CMDS[1]="(valgrind --tool=memcheck %s) 2>&1 | grep heap | tr -s ' ' | cut -d ' ' -f 9" # heap bytes used
# test has no relevance, since it encryption / decryption is cpy intensive and has all the writes are made by the wrapper program
TEST_CMDS[2]="(strace -c %s) 2>&1 | grep write | tr -s ' ' | cut -d ' ' -f 5" # no of write calls
TEST_CMDS[3]="perf stat --log-fd 1 %s | grep instructions | tr -s ' ' | cut -d ' ' -f 2"

TEST_NAMES=()

init() {
	make
}

initial_test() {
    echo "Checking if run environment is safe: "

    touch $FILE

    RET=0

    $BINARY 0 0 2 $FILE $ENCFILE
    if [ 0 -ne $? ]; then
        echo "FAIL: Unable to run $BINARY in this environment"
        RET=1
    fi

    for binary in "time" "strace" "valgrind" "perf"; do
        which $binary &> /dev/null
        if [ 0 -ne $? ]; then
            echo "Please install $binary on your machine"
            RET=1
        fi
    done

    if [ 1 -eq $RET ]; then
        exit 1
    fi

    echo "Cool. On with the tests."

    rm -f $FILE $ENCFILE
}

clean() {
	make clean
	rm -f $FILE $ENCFILE $DECFILE
}

# ============================================================================
# this section here is the code

init

initial_test

for test_cmd in 0 1 3; do
	echo "Testing " ${TEST_CMDS[$test_cmd]}
	for file_size in ${FILE_SIZES[@]}; do
		echo "Testing for file size " $file_size

		dd if=/dev/urandom of=$FILE bs=1M count=$file_size &> /dev/null

		for way in 0 1; do

			if [ $way -eq 0 ]; then
				echo "Encrypt:"
			else
				echo "Decrypt:"
			fi

			# print the row header
			printf "%20s" "CHUNK SIZE:"
			for chunk_size in ${CHUNK_SIZES[@]}; do
				printf "%20d" "$chunk_size"
			done
			printf "\n"

			for lib_id in 0 1 2; do
				printf "%20s" ${LIB_NAMES[$lib_id]}

				for chunk_size in ${CHUNK_SIZES[@]}; do

					test="$BINARY $way $lib_id $chunk_size $FILE $ENCFILE"
					# echo "$test"
					cmd=$(printf "${TEST_CMDS[$test_cmd]}" "$test")

					# echo $cmd

					val=$(eval $cmd)
					printf "%20s" $val

				done

				printf "\n"
			done

			printf "\n"

		done
	done
done

clean
