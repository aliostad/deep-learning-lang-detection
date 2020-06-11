############################################################################## 
# Compile programs on Mist
############################################################################## 
gcc -o serial calcpi_serial.c
gcc -o omp -fopenmp calcpi_openmp.c
#g++ -o tbb -L/usr/local/packages/intel_xe/14.0.1/tbb/lib/intel64/gcc4.1 -ltbb calcpi_tbb.cpp
icpc -o cilk calcpi_cilk.cpp

############################################################################## 
# Run examples
############################################################################## 
rm sampleOutput.txt
touch sampleOutput.txt
./serial 10000000 >> sampleOutput.txt
echo "********************************************************************" >> sampleOutput.txt
./omp 8 10000000 >> sampleOutput.txt
echo "********************************************************************" >> sampleOutput.txt
#./tbb 8 1000000  >> sampleOutput.txt
#echo "********************************************************************" >> sampleOutput.txt
./cilk 8 10000000 >> sampleOutput.txt

############################################################################## 
# Remove executables
############################################################################## 
rm serial omp cilk
#rm serial omp tbb cilk
