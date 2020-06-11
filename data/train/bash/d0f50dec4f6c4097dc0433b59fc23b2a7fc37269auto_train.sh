#!/bin/bash


#rm example4/ntrainSample.txt example4/ntestSample.txt
#echo example4/nntrainSample.txt example4/ntrainSample.txt example4/ntestSample.txt |php randomGen.php

#echo example4/nntrainSample.txt example4/ntrainSample.txt example4/ntestSample.txt example4/hosts.txt example4/tr_host.txt example4/te_host.txt |php randomGen.php
./svm_multiclass_learn.exe -c 5000 temp/med/train.txt temp/med/model
#./svm_multiclass_classify example4/test_format.txt example4/model example4/predictions >> log.txt
#echo example4/ntestSample.txt example4/te_host.txt example4/tag_index.txt example4/predictions example4/nprediction.txt example4/wsf.txt |php predInterface.php  >> log.txt



