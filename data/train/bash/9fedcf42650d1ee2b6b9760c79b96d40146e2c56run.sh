#!/bin/sh

./bin/train $1 data/model_init.txt data/seq_model_01.txt model_01.txt 
./bin/train $1 data/model_init.txt data/seq_model_02.txt model_02.txt 
./bin/train $1 data/model_init.txt data/seq_model_03.txt model_03.txt 
./bin/train $1 data/model_init.txt data/seq_model_04.txt model_04.txt 
./bin/train $1 data/model_init.txt data/seq_model_05.txt model_05.txt 
./bin/test data/modellist.txt data/testing_data1.txt result1.txt data/testing_answer.txt > acc.txt
./bin/test data/modellist.txt data/testing_data2.txt result2.txt

