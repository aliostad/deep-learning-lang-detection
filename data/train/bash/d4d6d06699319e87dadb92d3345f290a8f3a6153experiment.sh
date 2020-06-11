#!/bin/sh

rm model_0*.txt

cp data/model_init.txt model_01.txt
cp data/model_init.txt model_02.txt
cp data/model_init.txt model_03.txt
cp data/model_init.txt model_04.txt
cp data/model_init.txt model_05.txt

for i in {1..1000}
do
    ./bin/train 1 model_01.txt data/seq_model_01.txt model_01.txt 
    ./bin/train 1 model_02.txt data/seq_model_02.txt model_02.txt 
    ./bin/train 1 model_03.txt data/seq_model_03.txt model_03.txt 
    ./bin/train 1 model_04.txt data/seq_model_04.txt model_04.txt 
    ./bin/train 1 model_05.txt data/seq_model_05.txt model_05.txt 
    ./bin/test data/modellist.txt data/testing_data1.txt result1.txt data/testing_answer.txt
done

