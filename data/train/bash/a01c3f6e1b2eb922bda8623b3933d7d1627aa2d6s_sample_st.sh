#!/bin/bash
#
#  Compile
#
gcc -c -I/$HOME/include s_sample_st.c
if [ $? -ne 0 ]; then
  echo "Errors compiling s_sample_st.c"
  exit
fi
#
#  Link and load
#
#gcc s_sample_st.o -L$HOME/lib/$ARCH \
#  -L/$HOME/libc/$ARCH -lsuperlu_4.3 -lm -lblas
gfortran s_sample_st.o -L$HOME/lib/$ARCH \
  -L/$HOME/libc/$ARCH -lsuperlu_4.3 -lm -lblas
#gcc s_sample_st.o -L$HOME/lib/$ARCH \
#  -L/$HOME/libc/$ARCH -lsuperlu_4.3 -lm -framework veclib
if [ $? -ne 0 ]; then
  echo "Errors linking and loading s_sample_st.o"
  exit
fi
rm s_sample_st.o
mv a.out s_sample_st
#
#  Run
#
./s_sample_st < sample_rst.txt > s_sample_st_output.txt
if [ $? -ne 0 ]; then
  echo "Errors running s_sample_st"
  exit
fi
rm s_sample_st
#
#  Terminate.
#
echo "Program output written to s_sample_st_output.txt"
