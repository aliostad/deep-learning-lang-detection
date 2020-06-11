#!/bin/sh

SAMPLES=3


#OUT=baseline_application.raw
#for i in {1..3}
#do
#	echo $i
#	./fadvise-readAhead.withoutfadvise.stride12288.think100 >> $OUT
#done

#for CHUNK in 104858 209715 314573 419430 524288 629146 734003 838861 943718 1048576 2097152 3145728 4194304 5242880 6291456 7340032 8388608 9437184 10485760;

#for CHUNK in 1 10 105 210 315 419 524 629 734 839 944 1049 2097 3146 4194 5243 6291 7340 8389 9437 10486 20972 31457 41943 52429 62915 73400 83886 94372 104858 209715 314573 419430 524288 629146 734003 838861 943718 1048576 2097152 3145728 4194304 5242880 6291456 7340032 8388608 9437184 10485760;
for CHUNK in 2 4 8 16 32 64 128 256 512 1024 2048 4096 8192 16384 32768 65536 131072 262144 524288 1048576 2097152 4194304 8388608 16777216;
do
	echo $CHUNK

	OUT=optimized_replay_${CHUNK}.csv
	echo "us,us/op,op/us" > $OUT
	for i in {1..3}
	do
		echo $i
		./replay.sh demo-trace $CHUNK --loglevel 0 $@ | grep "csv:" | sed -r 's/^.{4}//' >> $OUT
	done
done

OUT=baseline_replay.csv
echo "us,us/op,op/us" > $OUT
for i in {1..3}
do
	echo $i
	./replay_unoptimized.sh demo-trace --loglevel 0 $@ | grep "csv:" | sed -r 's/^.{4}//' >> $OUT
done

cd demo-measures
make update
make
