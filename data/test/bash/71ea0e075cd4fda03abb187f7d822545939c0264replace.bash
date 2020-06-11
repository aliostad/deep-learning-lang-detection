#!/bin/bash

scriptname=`basename $0`
EXPECTED_ARGS=2

if [ $# -ne $EXPECTED_ARGS ]
then
    echo "Usage: $scriptname foldername EOSDirVersion"
    echo "Example: ./$scriptname Zprime_A0h_A0chichi_MZp1000_MA0300 v1"
    exit 1
fi


type=$1
version=$2
process=${type%%_MZp*}
echo $process
if [[ ! -e $process ]]; then 
    mkdir $process
fi
location="\/cvmfs\/cms.cern.ch\/phys_generator\/gridpacks\/slc6_amd64_gcc481\/13TeV\/madgraph\/V5_2.2.2\/monoHiggs\/${process}\/${version}\/${type}_tarball.tar.xz"
echo $location
filename=${type}_13TeV-madgraph_cff.py
echo $filename >> file.txt

sed -e 's/PROCESS/'$process'/g' -e 's/TYPE/'$type'/g' -e 's/LOCATION/'$location'/g' template_cff.py > $process/$filename
