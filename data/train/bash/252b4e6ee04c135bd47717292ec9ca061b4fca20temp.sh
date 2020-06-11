#!/bin/bash

opt -load ~/ioc-build/projects/poolalloc/Release+Asserts/lib/LLVMDataStructure.so -load ~/ioc-build/projects/poolalloc/Release+Asserts/lib/AssistDS.so -load ~/ioc-build/projects/llvm-deps/Release+Asserts/lib/pointstointerface.so -load ~/ioc-build/projects/llvm-deps/Release+Asserts/lib/sourcesinkanalysis.so -load ~/ioc-build/projects/llvm-deps/Release+Asserts/lib/Constraints.so -load ~/ioc-build/projects/llvm-deps/Release+Asserts/lib/Deps.so -load ~/ioc-build/projects/llvm-deps/Release+Asserts/lib/InfoApp.so -mem2reg -infoapp < $1 > temp.bc

rm temp.bc
