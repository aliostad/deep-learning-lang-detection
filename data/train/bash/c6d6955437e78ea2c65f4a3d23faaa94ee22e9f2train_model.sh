#! /bin/bash

set -x
make all
if [ -z "$2" ]
	then
		model_file="./model/test.model"
	else
		model_file=$2
fi

if [ -z "$1" ]
	then
		train_file="./data/test_iphone_train_1030_sorted.data"
	else
		train_file=$1
fi

./rankboost -f ${train_file} -o ${model_file} -s 300
# ./rbtest -m ${model_file} -t ./data/test_iphone_train_1030.data -n 5
# ./rbtest -m ${model_file} -t ./data/test_iphone_test_1030.data -n 6
# ./rbtest -m ${model_file} -t ./data/test_iphone_test_1030.data -n 7
# echo ${model_file}
# echo ${train_file}

python model/compare_feature.py model/test.model model/fea_id_name_iPhone.dict model/merge_test
./test_model.sh