
work=./
cfg=./examples/model.cfg
out=./examples_output
linear_reg_model=$out/model.linear_reg
logistic_reg_model=$out/model.logistic_reg

if ! echo $PYTHONPATH | egrep -q "(^|:)$work($|:)" 
then
    export PYTHONPATH=$PYTHONPATH:$work
fi

if [ ! -d $out ]
then
    mkdir examples_output
fi

# training model
python ./examples/linear_reg_example.py -c $cfg -m $linear_reg_model
python ./examples/logistic_reg_example.py -c $cfg -m $logistic_reg_model

echo "linear regression model: $linear_reg_model"
echo "logistic regression model: $logistic_reg_model"

