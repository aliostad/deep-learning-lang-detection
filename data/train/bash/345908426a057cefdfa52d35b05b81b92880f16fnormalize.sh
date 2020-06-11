#!/bin/bash

if [ $# -lt 8 ];
then
    echo ""
    echo "Usage: $0 file n k D c f d m l"
    echo "    where file = path to XML config file that serves as template"
    echo "          (n,k) are from the encoding scheme"
    echo "          D = total data to be stored (in PB, unreplicated)"
    echo "          c = capacity of each disk (in TB)"
    echo "          f = fraction of disk capacity not to be exceeded (eg, 0.833 = 5/6)"
    echo "          d = number of disks per machine"
    echo "          m = number of machines per rack"
    echo "          l = size of a slice (in MB)"
    echo ""
    echo "Note: This script assumes number of data centers = 1"
    echo ""
    exit 1
fi

n=$1
k=$2
D=$3
c=$4
f=$5
d=$6
m=$7
l=$8

chunkSize=`echo "$l/$k" | bc -l`
chunksPerDisk=`echo "10^6*$c/$chunkSize" | bc -l`
numRacks=`echo "10^3*$D*$n/($k*$f*$c*$d*$m)" | bc -l`

echo "chunk size in MB = $chunkSize"
echo "num chunks per disk = $chunksPerDisk"
echo "num racks = $numRacks"


