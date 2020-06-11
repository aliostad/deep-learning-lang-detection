#!/bin/bash
#
#  Compile
#
gcc -c -I/$HOME/include z_sample.c
if [ $? -ne 0 ]; then
  echo "Errors compiling z_sample.c"
  exit
fi
#
#  Link and load
#
#gcc z_sample.o -L$HOME/lib/$ARCH \
#  -L/$HOME/libc/$ARCH -lsuperlu_4.3 -lm -lblas
gfortran z_sample.o -L$HOME/lib/$ARCH \
  -L/$HOME/libc/$ARCH -lsuperlu_4.3 -lm -lblas
#gcc z_sample.o -L$HOME/lib/$ARCH \
#  -L/$HOME/libc/$ARCH -lsuperlu_4.3 -lm -framework veclib
if [ $? -ne 0 ]; then
  echo "Errors linking and loading z_sample.o"
  exit
fi
rm z_sample.o
mv a.out z_sample
#
#  Run
#
./z_sample > z_sample_output.txt
if [ $? -ne 0 ]; then
  echo "Errors running z_sample"
  exit
fi
rm z_sample
#
#  Terminate.
#
echo "Program output written to z_sample_output.txt"
