#!/bin/bash

clang $IOC_FLAGS -emit-llvm -S $1.c -o $1.ll

opt -load ~/ioc-build/projects/poolalloc/Release+Asserts/lib/LLVMDataStructure.so -load ~/ioc-build/projects/poolalloc/Release+Asserts/lib/AssistDS.so -load ~/ioc-build/projects/llvm-deps/Release+Asserts/lib/pointstointerface.so -load ~/ioc-build/projects/llvm-deps/Release+Asserts/lib/sourcesinkanalysis.so -load ~/ioc-build/projects/llvm-deps/Release+Asserts/lib/Constraints.so -load ~/ioc-build/projects/llvm-deps/Release+Asserts/lib/Deps.so -load ~/ioc-build/projects/llvm-deps/Release+Asserts/lib/InfoApp.so -mem2reg -infoapp < $1.ll > temp.bc

rm temp.bc
rm $1.ll
