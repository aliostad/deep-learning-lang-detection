#!/bin/bash -e

./plot.py 0 --save-eps
./plot.py 0 --save-eps --total-time
./plot.py 1 --save-eps
./plot.py 1 --save-eps --plot-sum
./plot.py 2 --save-eps --plot-sum
./plot.py 2 --save-eps

./plot-with-cuts.py 0 --save-eps
./plot-with-cuts.py 2 --save-eps

./plot.py 1 --master --save-eps
./plot.py 2 --master --save-eps

./plot.py 1 --premizan --save-eps
./plot.py 2 --premizan --save-eps --plot-sum
./plot.py 2 --premizan --save-eps
./plot.py 1 --premizan --master --save-eps
./plot.py 2 --premizan --master --save-eps