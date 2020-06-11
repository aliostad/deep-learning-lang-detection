make

./train 180 ../hmm_model/model_init.txt ../seq_model/seq_model_01.txt ../hmm_model/model_01.txt
./train 180 ../hmm_model/model_init.txt ../seq_model/seq_model_02.txt ../hmm_model/model_02.txt
./train 180 ../hmm_model/model_init.txt ../seq_model/seq_model_03.txt ../hmm_model/model_03.txt
./train 180 ../hmm_model/model_init.txt ../seq_model/seq_model_04.txt ../hmm_model/model_04.txt
./train 180 ../hmm_model/model_init.txt ../seq_model/seq_model_05.txt ../hmm_model/model_05.txt

./test  ../hmm_model/modellist.txt ../data/testing_data1.txt ../result/result1.txt
./test  ../hmm_model/modellist.txt ../data/testing_data2.txt ../result/result2.txt

make clean