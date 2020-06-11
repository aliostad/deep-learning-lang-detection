#!/bin/bash

ModelName[0]="In_Alone_MultiTask_Clock"
ModelName[1]="In_Alone_MultiTask_RS232"
ModelName[2]="In_Alone_SingleTask_Clock"
ModelName[3]="In_Alone_SingleTask_RS232"
ModelName[4]="InOut_Full_MultiTask_Clock"
ModelName[5]="InOut_Full_MultiTask_RS232"
ModelName[6]="InOut_Full_SingleTask_Clock"
ModelName[7]="InOut_Full_SingleTask_RS232"
ModelName[8]="Out_Alone_MultiTask_Clock"
ModelName[9]="Out_Alone_SingleTask_Clock"

NbFile=10

# Try to compile all the models
for index in `seq 0 $NbFile`
do
    eval n | ./UpToDateModel "${ModelName[$index]}"
done 

# Test if compilation has succeed 
for index in `seq 0 $NbFile`
do
    # Model_1
    exec_name=COM_"${ModelName[$index]}"_RT
    model_name="${ModelName[$index]}"
    eval res=`ls ./Sources/COM_"$model_name"_sources |grep "$exec_name"`
    if test $res = $exec_name
    then
        echo "$model_name: SUCCESSFULLY COMPILED!"    
    else
        echo "$model_name: COMPILATION FAILED!"
    fi
done