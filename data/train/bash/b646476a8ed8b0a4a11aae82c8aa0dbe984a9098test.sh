#!/bin/sh
err(){
    printf '%s\n' "$1"
    exit 1
}
invoke(){
    printf '%s\n' "$1"
    sh -c "$1" || err "Invocation \"$1\" failed with exit code $?"
}

rm -f testfile*

testdata="$(dd if=/dev/urandom bs=1024 count=1024|openssl base64)"
printf "$testdata" > testfile

invoke "./s2png testfile"
invoke "test -e testfile.png"
invoke "cp testfile.png testfile2.png"
invoke "rm -f testfile.png"
invoke "./s2png -e testfile"
invoke "test -e testfile.png"
invoke "cmp testfile.png testfile2.png"
invoke "./s2png -e -b \"Hello world!\" -o - - < testfile > testfile.png"
invoke "./s2png -d -o testfile2 - < testfile.png"
invoke "cmp testfile testfile2"

printf 's2png has passed all tests.\n'

rm -f testfile*