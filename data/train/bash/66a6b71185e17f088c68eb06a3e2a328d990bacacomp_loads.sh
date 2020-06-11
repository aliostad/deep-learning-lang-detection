#!/bin/sh
echo "pkl"
echo 1 > /proc/sys/vm/drop_caches
kernprof -l comp_pkl_load.py

echo "mat"
echo 1 > /proc/sys/vm/drop_caches
kernprof -l comp_mat_load.py

echo "npy"
echo 1 > /proc/sys/vm/drop_caches
kernprof -l comp_npy_load.py

echo "hdf5"
echo 1 > /proc/sys/vm/drop_caches
kernprof -l comp_hdf5_load.py

echo "show results"
python -m line_profiler comp_pkl_load.py.lprof
python -m line_profiler comp_mat_load.py.lprof
python -m line_profiler comp_npy_load.py.lprof
python -m line_profiler comp_hdf5_load.py.lprof
