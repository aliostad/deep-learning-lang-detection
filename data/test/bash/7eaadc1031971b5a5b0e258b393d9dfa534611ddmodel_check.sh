#!/bin/sh

# File Name: model_check.sh
# Author   : Jerson_Lin
# Date     : 2008-09-23
# Purpose  : for check previous model type of build code
# Usage    : ./model_check.sh MODEL_NAME

MODEL_FILE=./MODEL

# check input model name
if [ $# == 0 ]; then
   echo "Please input model name!!!"
   echo "Usage: ./model_check.sh MODEL_NAME"
   echo "Ex   : ./model_check.sh NSA220"
   exit 1
else
   BUILD_MODEL=$1
fi

# check previous model name
if [ -e $MODEL_FILE ]; then
   PREV_MODEL=`grep "Model" $MODEL_FILE | awk -F " " '{print $3}'`
   if [ "$PREV_MODEL" != "$BUILD_MODEL" ]; then
      echo "Previous build mode is $PREV_MODEL, please make clean first"
      exit 1
   fi
else 
   # create model file
   echo "Create MODEL file....."
   echo "Model is $BUILD_MODEL" > $MODEL_FILE
fi

exit 0
