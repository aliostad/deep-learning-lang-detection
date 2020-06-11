#!/bin/sh
echo "pkl"
echo 1 > /proc/sys/vm/drop_caches
kernprof -l comp_pkl_load_n.py

echo "mat"
echo 1 > /proc/sys/vm/drop_caches
kernprof -l comp_mat_load_n.py

echo "npy"
echo 1 > /proc/sys/vm/drop_caches
kernprof -l comp_npy_load_n.py

echo "hdf5"
echo 1 > /proc/sys/vm/drop_caches
kernprof -l comp_hdf5_load_n.py

echo "show results"
python -m line_profiler comp_pkl_load_n.py.lprof
python -m line_profiler comp_mat_load_n.py.lprof
python -m line_profiler comp_npy_load_n.py.lprof
python -m line_profiler comp_hdf5_load_n.py.lprof


