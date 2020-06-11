#!/bin/bash
#
#  Compile
#
gcc -c -I/$HOME/include d_sample.c
if [ $? -ne 0 ]; then
  echo "Errors compiling d_sample.c"
  exit
fi
#
#  Link and load
#
#gcc d_sample.o -L$HOME/lib/$ARCH \
#  -L/$HOME/libc/$ARCH -lsuperlu_4.3 -lm -lblas
gfortran d_sample.o -L$HOME/lib/$ARCH \
  -L/$HOME/libc/$ARCH -lsuperlu_4.3 -lm -lblas
#gcc d_sample.o -L$HOME/lib/$ARCH \
#  -L/$HOME/libc/$ARCH -lsuperlu_4.3 -lm -framework veclib
if [ $? -ne 0 ]; then
  echo "Errors linking and loading d_sample.o"
  exit
fi
rm d_sample.o
mv a.out d_sample
#
#  Run
#
./d_sample > d_sample_output.txt
if [ $? -ne 0 ]; then
  echo "Errors running d_sample"
  exit
fi
rm d_sample
#
#  Terminate.
#
echo "Program output written to d_sample_output.txt"
