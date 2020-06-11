#!/bin/bash

gcc -I../include -o sample main.c use_cbrt.c -L../lib/dynamic -lamdlibm -lm
LD_LIBRARY_PATH=../lib/dynamic:$LD_LIBRARY_PATH ./sample
rm -rf sample *.o
echo -e "\n--------------------------------------------\n"

g++ -I../include -o sample main.cpp use_cbrt.cpp -L../lib/dynamic -lamdlibm -lm
LD_LIBRARY_PATH=../lib/dynamic:$LD_LIBRARY_PATH ./sample
rm -rf sample *.o
echo -e "\n--------------------------------------------\n"

gcc -I../include -o sample replace_compiler_sin.c -L../lib/dynamic -lamdlibm -lm
LD_LIBRARY_PATH=../lib/dynamic:$LD_LIBRARY_PATH ./sample
rm -rf sample *.o
echo -e "\n--------------------------------------------\n"

gcc -I../include -o sample replace_compiler_math_fns.c -L../lib/dynamic -lamdlibm -lm
LD_LIBRARY_PATH=../lib/dynamic:$LD_LIBRARY_PATH ./sample
rm -rf sample *.o
echo -e "\n--------------------------------------------\n"

