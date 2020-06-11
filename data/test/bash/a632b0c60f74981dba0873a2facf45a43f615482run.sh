export LD_LIBRARY_PATH=/home/staff/rodolfo/mc723/systemc/lib-linux64:$LD_LIBRARY_PATH
export PATH=/home/staff/rodolfo/mc723/archc/bin:/home/staff/rodolfo/compilers/bin:$PATH

#./mips.x --load=./../MipsMibench/automotive/qsort/qsort_small ./../MipsMibench/automotive/qsort/input_small.dat
# ./mips.x --load=./../MipsMibench/automotive/qsort/qsort_large ./../MipsMibench/automotive/qsort/input_large.dat
# ./mips.x --load=./../MipsMibench/automotive/susan/susan
# ./mips.x --load=./../MipsMibench/security/sha/sha
./mips.x --load=./../MipsMibench/network/dijkstra/dijkstra_small ./../MipsMibench/network/dijkstra/input.dat
# ./mips.x --load=./../MipsMibench/telecomm/FFT/fft
# ./mips.x --load=./../MipsMibench/automotive/bitcount/bitcnts 1125000

