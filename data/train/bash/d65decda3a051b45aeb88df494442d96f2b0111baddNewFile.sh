#!/bin/bash


[[ $# -lt 1 ]] && echo "$0 -c new_case_name" && exit;

while [ $# != 0 ]
do case "$1" in

	-c) case=$2 ; shift ;;


	*) echo "$0 -c new_case_name" && exit;

esac
shift
done

echo "***Running*****"

# handle the header file
sed s/Sample/$case/g SampleHeader.h > $case.h

## CMake file
cp CMakeLists.txt CMakeLists.txt.bak
#sed s/SampleHeader/SampleHeader\.h\\n\\t$case/g CMakeLists.txt > a
perl -pe "s/SampleHeader/SampleHeader\.h\n\t$case/g" CMakeLists.txt > a
mv a CMakeLists.txt

## cpp file
cp LeetCodeSolutions.cpp LeetCodeSolutions.cpp.bak
#sed s/SampleHeader/$case\.h\"\\n#include\ \"SampleHeader/g LeetCodeSolutions.cpp > a
perl -pe "s/SampleHeader/$case\.h\"\n#include\ \"SampleHeader/g" LeetCodeSolutions.cpp > a
mv a LeetCodeSolutions.cpp

echo "***Finished*****"
