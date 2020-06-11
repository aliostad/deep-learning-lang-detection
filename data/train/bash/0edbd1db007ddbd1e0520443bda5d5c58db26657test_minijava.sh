#!/bin/bash

opt -load Release/P3.so -deadLoad -dcep3 tests/minijava/BinarySearch.bc >results/BinarySearch.bc.dce
opt -load Release/P3.so -deadLoad -dcep3 tests/minijava/BinaryTree.bc >results/BinaryTree.bc.dce
opt -load Release/P3.so -deadLoad -dcep3 tests/minijava/BubbleSort.bc >results/BubbleSort.bc.dce
opt -load Release/P3.so -deadLoad -dcep3 tests/minijava/Factorial.bc >results/Factorial.bc.dce
opt -load Release/P3.so -deadLoad -dcep3 tests/minijava/LinearSearch.bc >results/LinearSearch.bc.dce
opt -load Release/P3.so -deadLoad -dcep3 tests/minijava/LinkedList.bc >results/LinkedList.bc.dce
opt -load Release/P3.so -deadLoad -dcep3 tests/minijava/QuickSort.bc >results/QuickSort.bc.dce
opt -load Release/P3.so -deadLoad -dcep3 tests/minijava/TreeVisitor.bc >results/TreeVisitor.bc.dce


