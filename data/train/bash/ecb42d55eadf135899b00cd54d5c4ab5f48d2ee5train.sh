#!/usr/bin/env sh

for i in $(seq 1 2)
do
	./train 1 model_01.txt seq_model_01.txt model_01.txt &
	./train 1 model_02.txt seq_model_02.txt model_02.txt &
	./train 1 model_03.txt seq_model_03.txt model_03.txt &
	./train 1 model_04.txt seq_model_04.txt model_04.txt &
	./train 1 model_05.txt seq_model_05.txt model_05.txt &
	wait
	echo " ($i iters)"
	./test modellist.txt testing_data1.txt result1.txt acc.txt
	./test modellist.txt testing_data2.txt result2.txt
	cat acc.txt
done

#echo "Testing Start"
#./test modellist.txt testing_data1.txt result1.txt acc.txt
