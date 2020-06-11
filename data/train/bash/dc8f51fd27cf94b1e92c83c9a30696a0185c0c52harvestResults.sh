#!/bin/bash

BASEDIR=`pwd`

:<<'STOPHERE'
result=""
cd $BASEDIR
cd numHostsTests1
dirs="`ls -F | grep "/"`"
for testdir in $dirs
do
	numHosts=${testdir:0:${#testdir}-1}
	numHosts=${numHosts#'hosts_'}
	cd $testdir
	result=${result}${numHosts}"\t"`tail -n 1 output.error | awk '{print $3}'`"\n"
	cd ..
done
cd $BASEDIR
echo -e $result > results_numHosts1.txt

result=""
cd $BASEDIR
cd numHostsTests2
dirs="`ls -F | grep "/"`"
for testdir in $dirs
do
	numHosts=${testdir:0:${#testdir}-1}
	numHosts=${numHosts#'hosts_'}
	cd $testdir
	result=${result}${numHosts}"\t"`tail -n 1 output.error | awk '{print $3}'`"\n"
	cd ..
done
cd $BASEDIR
echo -e $result > results_numHosts2.txt

result=""
cd $BASEDIR
cd numHostsTests3
dirs="`ls -F | grep "/"`"
for testdir in $dirs
do
	numHosts=${testdir:0:${#testdir}-1}
	numHosts=${numHosts#'hosts_'}
	cd $testdir
	result=${result}${numHosts}"\t"`tail -n 1 output.error | awk '{print $3}'`"\n"
	cd ..
done
cd $BASEDIR
echo -e $result > results_numHosts3.txt

result=""
cd $BASEDIR
cd numHostsTests4
dirs="`ls -F | grep "/"`"
for testdir in $dirs
do
	numHosts=${testdir:0:${#testdir}-1}
	numHosts=${numHosts#'hosts_'}
	cd $testdir
	result=${result}${numHosts}"\t"`tail -n 1 output.error | awk '{print $3}'`"\n"
	cd ..
done
cd $BASEDIR
echo -e $result > results_numHosts4.txt

result=""
cd $BASEDIR
cd numHostsTests5
dirs="`ls -F | grep "/"`"
for testdir in $dirs
do
	numHosts=${testdir:0:${#testdir}-1}
	numHosts=${numHosts#'hosts_'}
	cd $testdir
	result=${result}${numHosts}"\t"`tail -n 1 output.error | awk '{print $3}'`"\n"
	cd ..
done
cd $BASEDIR
echo -e $result > results_numHosts5.txt

################################################################

result=""
cd $BASEDIR
cd numHostsTests_oneAS1
dirs="`ls -F | grep "/"`"
result=""
for testdir in $dirs
do
	numHosts=${testdir:0:${#testdir}-1}
	numHosts=${numHosts#'hosts_'}
	cd $testdir
	result=${result}${numHosts}"\t"`tail -n 1 output.error | awk '{print $3}'`"\n"
	cd ..
done
cd $BASEDIR
echo -e $result > results_numHosts_oneAS1.txt

result=""
cd $BASEDIR
cd numHostsTests_oneAS2
dirs="`ls -F | grep "/"`"
result=""
for testdir in $dirs
do
	numHosts=${testdir:0:${#testdir}-1}
	numHosts=${numHosts#'hosts_'}
	cd $testdir
	result=${result}${numHosts}"\t"`tail -n 1 output.error | awk '{print $3}'`"\n"
	cd ..
done
cd $BASEDIR
echo -e $result > results_numHosts_oneAS2.txt

result=""
cd $BASEDIR
cd numHostsTests_oneAS3
dirs="`ls -F | grep "/"`"
result=""
for testdir in $dirs
do
	numHosts=${testdir:0:${#testdir}-1}
	numHosts=${numHosts#'hosts_'}
	cd $testdir
	result=${result}${numHosts}"\t"`tail -n 1 output.error | awk '{print $3}'`"\n"
	cd ..
done
cd $BASEDIR
echo -e $result > results_numHosts_oneAS3.txt

result=""
cd $BASEDIR
cd numHostsTests_oneAS4
dirs="`ls -F | grep "/"`"
result=""
for testdir in $dirs
do
	numHosts=${testdir:0:${#testdir}-1}
	numHosts=${numHosts#'hosts_'}
	cd $testdir
	result=${result}${numHosts}"\t"`tail -n 1 output.error | awk '{print $3}'`"\n"
	cd ..
done
cd $BASEDIR
echo -e $result > results_numHosts_oneAS4.txt

result=""
cd $BASEDIR
cd numHostsTests_oneAS5
dirs="`ls -F | grep "/"`"
result=""
for testdir in $dirs
do
	numHosts=${testdir:0:${#testdir}-1}
	numHosts=${numHosts#'hosts_'}
	cd $testdir
	result=${result}${numHosts}"\t"`tail -n 1 output.error | awk '{print $3}'`"\n"
	cd ..
done
cd $BASEDIR
echo -e $result > results_numHosts_oneAS5.txt
STOPHERE
################################################################

result=""
cd $BASEDIR
cd BWTests1
dirs="`ls -F | grep "/"`"
result=""
for testdir in $dirs
do
	BW=${testdir:0:${#testdir}-1}
	BW=${BW#'BW_'}
	cd $testdir
	result=${result}${BW}"\t"`tail -n 1 output.error | awk '{print $3}'`"\n"
	cd ..
done
cd $BASEDIR
echo -e $result > results_BW1.txt

result=""
cd $BASEDIR
cd BWTests2
dirs="`ls -F | grep "/"`"
result=""
for testdir in $dirs
do
	BW=${testdir:0:${#testdir}-1}
	BW=${BW#'BW_'}
	cd $testdir
	result=${result}${BW}"\t"`tail -n 1 output.error | awk '{print $3}'`"\n"
	cd ..
done
cd $BASEDIR
echo -e $result > results_BW2.txt

result=""
cd $BASEDIR
cd BWTests3
dirs="`ls -F | grep "/"`"
result=""
for testdir in $dirs
do
	BW=${testdir:0:${#testdir}-1}
	BW=${BW#'BW_'}
	cd $testdir
	result=${result}${BW}"\t"`tail -n 1 output.error | awk '{print $3}'`"\n"
	cd ..
done
cd $BASEDIR
echo -e $result > results_BW3.txt

result=""
cd $BASEDIR
cd BWTests4
dirs="`ls -F | grep "/"`"
result=""
for testdir in $dirs
do
	BW=${testdir:0:${#testdir}-1}
	BW=${BW#'BW_'}
	cd $testdir
	result=${result}${BW}"\t"`tail -n 1 output.error | awk '{print $3}'`"\n"
	cd ..
done
cd $BASEDIR
echo -e $result > results_BW4.txt

result=""
cd $BASEDIR
cd BWTests5
dirs="`ls -F | grep "/"`"
result=""
for testdir in $dirs
do
	BW=${testdir:0:${#testdir}-1}
	BW=${BW#'BW_'}
	cd $testdir
	result=${result}${BW}"\t"`tail -n 1 output.error | awk '{print $3}'`"\n"
	cd ..
done
cd $BASEDIR
echo -e $result > results_BW5.txt

:<<'STOPHERE2'
#################################################################


result=""
cd $BASEDIR
cd chunkSizeTests1
dirs="`ls -F | grep "/"`"
result=""
for testdir in $dirs
do
	chunkSize=${testdir:0:${#testdir}-1}
	chunkSize=${chunkSize#'chunkSize_'}
	cd $testdir
	result=${result}${chunkSize}"\t"`tail -n 1 output.error | awk '{print $3}'`"\n"
	cd ..
done
cd $BASEDIR
echo -e $result > results_chunkSize1.txt

result=""
cd $BASEDIR
cd chunkSizeTests2
dirs="`ls -F | grep "/"`"
result=""
for testdir in $dirs
do
	chunkSize=${testdir:0:${#testdir}-1}
	chunkSize=${chunkSize#'chunkSize_'}
	cd $testdir
	result=${result}${chunkSize}"\t"`tail -n 1 output.error | awk '{print $3}'`"\n"
	cd ..
done
cd $BASEDIR
echo -e $result > results_chunkSize2.txt

result=""
cd $BASEDIR
cd chunkSizeTests3
dirs="`ls -F | grep "/"`"
result=""
for testdir in $dirs
do
	chunkSize=${testdir:0:${#testdir}-1}
	chunkSize=${chunkSize#'chunkSize_'}
	cd $testdir
	result=${result}${chunkSize}"\t"`tail -n 1 output.error | awk '{print $3}'`"\n"
	cd ..
done
cd $BASEDIR
echo -e $result > results_chunkSize3.txt

result=""
cd $BASEDIR
cd chunkSizeTests4
dirs="`ls -F | grep "/"`"
result=""
for testdir in $dirs
do
	chunkSize=${testdir:0:${#testdir}-1}
	chunkSize=${chunkSize#'chunkSize_'}
	cd $testdir
	result=${result}${chunkSize}"\t"`tail -n 1 output.error | awk '{print $3}'`"\n"
	cd ..
done
cd $BASEDIR
echo -e $result > results_chunkSize4.txt

result=""
cd $BASEDIR
cd chunkSizeTests5
dirs="`ls -F | grep "/"`"
result=""
for testdir in $dirs
do
	chunkSize=${testdir:0:${#testdir}-1}
	chunkSize=${chunkSize#'chunkSize_'}
	cd $testdir
	result=${result}${chunkSize}"\t"`tail -n 1 output.error | awk '{print $3}'`"\n"
	cd ..
done
cd $BASEDIR
echo -e $result > results_chunkSize5.txt

#######################################################
result=""
cd $BASEDIR
cd mapperReducerTests1
dirs="`ls -F | grep "/"`"
result=""
for testdir in $dirs
do
	testdir=${testdir:0:${#testdir}-1}
	numMappers=`echo $testdir | awk 'BEGIN { FS = "_" } {print $2}'`
	numReducers=`echo $testdir | awk 'BEGIN { FS = "_" } {print $4}'`
	cd $testdir
	result=${result}${numMappers}"\t"${numReducers}"\t"`tail -n 1 output.error | awk '{print $3}'`"\n"
	cd ..
done
cd $BASEDIR
echo -e $result > results_mapperReducer1.txt

result=""
cd $BASEDIR
cd mapperReducerTests2
dirs="`ls -F | grep "/"`"
result=""
for testdir in $dirs
do
	testdir=${testdir:0:${#testdir}-1}
	numMappers=`echo $testdir | awk 'BEGIN { FS = "_" } {print $2}'`
	numReducers=`echo $testdir | awk 'BEGIN { FS = "_" } {print $4}'`
	cd $testdir
	result=${result}${numMappers}"\t"${numReducers}"\t"`tail -n 1 output.error | awk '{print $3}'`"\n"
	cd ..
done
cd $BASEDIR
echo -e $result > results_mapperReducer2.txt

result=""
cd $BASEDIR
cd mapperReducerTests3
dirs="`ls -F | grep "/"`"
result=""
for testdir in $dirs
do
	testdir=${testdir:0:${#testdir}-1}
	numMappers=`echo $testdir | awk 'BEGIN { FS = "_" } {print $2}'`
	numReducers=`echo $testdir | awk 'BEGIN { FS = "_" } {print $4}'`
	cd $testdir
	result=${result}${numMappers}"\t"${numReducers}"\t"`tail -n 1 output.error | awk '{print $3}'`"\n"
	cd ..
done
cd $BASEDIR
echo -e $result > results_mapperReducer3.txt

result=""
cd $BASEDIR
cd mapperReducerTests4
dirs="`ls -F | grep "/"`"
result=""
for testdir in $dirs
do
	testdir=${testdir:0:${#testdir}-1}
	numMappers=`echo $testdir | awk 'BEGIN { FS = "_" } {print $2}'`
	numReducers=`echo $testdir | awk 'BEGIN { FS = "_" } {print $4}'`
	cd $testdir
	result=${result}${numMappers}"\t"${numReducers}"\t"`tail -n 1 output.error | awk '{print $3}'`"\n"
	cd ..
done
cd $BASEDIR
echo -e $result > results_mapperReducer4.txt

result=""
cd $BASEDIR
cd mapperReducerTests5
dirs="`ls -F | grep "/"`"
result=""
for testdir in $dirs
do
	testdir=${testdir:0:${#testdir}-1}
	numMappers=`echo $testdir | awk 'BEGIN { FS = "_" } {print $2}'`
	numReducers=`echo $testdir | awk 'BEGIN { FS = "_" } {print $4}'`
	cd $testdir
	result=${result}${numMappers}"\t"${numReducers}"\t"`tail -n 1 output.error | awk '{print $3}'`"\n"
	cd ..
done
cd $BASEDIR
echo -e $result > results_mapperReducer5.txt
STOPHERE2

