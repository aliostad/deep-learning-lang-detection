set -e
if [ ! -n "$1" ] ;then
    echo "\$1 is empty, default is 0"
    gpu=0
else
    echo "use $1-th gpu"
    gpu=$1
fi

if [ ! -n "$2" ] ;then
    echo "\$2 is empty, default is vgg_reduce"
    base_model='vgg16'
else
    echo "use $2 as base model"
    base_model=$2
fi

if [ ! -n "$3" ] ;then
    echo "\$3 is empty, default is feature_name"
    feature_name='fc7'
else
    echo "use $3 as base model"
    feature_name=$3
fi
#base_model=caffenet
#base_model=vgg16
#base_model=googlenet
#base_model=res50
#feature_name=fc7
#feature_name=pool5/7x7_s1
#feature_name=pool5
model_file=./models/market1501/$base_model/snapshot/${base_model}.full_iter_18000.caffemodel

python examples/market1501/extract/extract_feature.py \
	examples/market1501/lists/test.lst \
	examples/market1501/datamat/test.lst.${base_model}.feature.mat \
	examples/market1501/datamat/test.lst.${base_model}.score.mat \
	--gpu $gpu \
	--model_def ./models/market1501/$base_model/dev.proto \
	--feature_name $feature_name \
	--pretrained_model $model_file \
	--mean_value 97.8286,99.0468,105.606

python examples/market1501/extract/extract_feature.py \
	examples/market1501/lists/query.lst \
	examples/market1501/datamat/query.lst.${base_model}.feature.mat \
	examples/market1501/datamat/query.lst.${base_model}.score.mat \
	--gpu $gpu \
	--model_def ./models/market1501/$base_model/dev.proto \
	--feature_name $feature_name \
	--pretrained_model $model_file \
	--mean_value 97.8286,99.0468,105.606
