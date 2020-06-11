c=$1
e=$2
i=$3
modelFile=$4
modelFolder=$5
suffix=$6
w=$7

cd fold$i
../../svm_python_learn --m svmstruct_mrf_act -c $c  -e $e -w $w --sf false --temporal true train$i.txt models/$modelFile >> logs/log.$suffix 2>> ../../errfile

sleep 2
../../svm_python_classify --m svmstruct_mrf_act --sf false --temporal true test$i.txt models/$modelFile pred/pred.$modelFile > pred/out.$modelFile 2>> ../../errfile
../../svm_python_classify --m svmstruct_mrf_act --sf false --temporal true cvtrain$i.txt models/$modelFile pred/cvtrain.pred.$modelFile > pred/cvtrain.out.$modelFile 2>> ../../errfile
#../../../svm_python_classify --m svmstruct_mrf_act --sf false --temporal true train$i.txt models/$modelFile pred/train.pred.$modelFile > pred/train.out.$modelFile 2>> ../../errfile
cd - 
