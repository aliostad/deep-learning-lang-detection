#!/bin/bash

# Make a record of the invocation and the original directory
INVOKE=$*
ORIGDIR=$(pwd)

mkdir -p ./output

# If there are not enough arguments, exit
if [ $# -lt 2 ]; then
  >&2 echo At least two arguments \(Run Number and Number of Procs\) required
  exit
fi

# Get the run number, and make a new directory for it
RunNumber=$1
if [ -d ./output/RUN_$RunNumber ]; then
 >&2 echo Run Number $RunNumber already exists
 exit
fi
mkdir ./output/RUN_$RunNumber

# Make a record of the properties files into the output directory
cp ./props/*.props ./output/RUN_$RunNumber/

# Write the invoke text as a record
echo $INVOKE >./output/RUN_$RunNumber/invoke.txt

# Change to the output directory
cd ./output/RUN_$RunNumber

# Pop the first argument off the list
shift

# Get the number of processes
NumProcs=$1

# Pop the second argument off the list
shift

# Start the run
mpirun -n $NumProcs $ORIGDIR/bin/beetles.exe config.props model.props $* >output.txt

# Return to the original directory
cd $ORIGDIR
