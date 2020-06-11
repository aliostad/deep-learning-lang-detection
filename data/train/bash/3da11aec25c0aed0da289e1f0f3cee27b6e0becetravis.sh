#!/bin/bash

set -ex

mkdir -p ./sample/common/a/a-1 ./sample/common/a/a-2/tmp ./sample/common/b/b-{1,2} ./sample/common/c/c-{1..3} ./sample/common/d ./sample/test

touch ./sample/common/a/a-1/{a-1.txt,test.html} ./sample/common/a/a-2/{tmp/a-2-tmp.txt,a-2.txt,test.html} \
./sample/common/b/b-1/b-1.txt ./sample/common/b/b-2/b-2.txt \
./sample/common/c/c-1/c-1{a,b}.txt ./sample/common/c/c-2/c-2{a,b,c}.txt ./sample/common/c/c-3/c-3.txt \
./sample/common/d/d.txt \
./sample/test/test.txt


dart --checked test/dfcsv_test.dart
