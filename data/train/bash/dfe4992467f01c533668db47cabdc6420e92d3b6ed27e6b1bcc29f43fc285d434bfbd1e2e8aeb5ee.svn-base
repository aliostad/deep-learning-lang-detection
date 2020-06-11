#!/bin/sh
setenv GCC_SUBST "/usr/local/gcc-2.95.3/bin/gcc"
cd $1
chmod -R +w *
yes '' | make config CC="/home/eecs/jkodumal/work/pldi05_experiments/banshee/experiments/gcc_subst.py -P -save-temps"
make dep CC="/home/eecs/jkodumal/work/pldi05_experiments/banshee/experiments/gcc_subst.py -P -save-temps"
make CC="/home/eecs/jkodumal/work/pldi05_experiments/banshee/experiments/gcc_subst.py -P -save-temps"
moke modules CC="/home/eecs/jkodumal/work/pldi05_experiments/banshee/experiments/gcc_subst.py -P -save-temps"
