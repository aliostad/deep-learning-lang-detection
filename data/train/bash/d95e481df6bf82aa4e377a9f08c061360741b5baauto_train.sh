#!/bin/bash

#for((i=0;i<10;i++))
#do
#./svm_multiclass_learn -c 5000 example4/ntrainSample.txt example4/model 
#./svm_multiclass_classify example4/ntestSample.txt example4/model example4/predictions >> log.txt
#rm example4/ntrainSample.txt example4/ntestSample.txt
#echo example4/nntrainSample.txt example4/ntrainSample.txt example4/ntestSample.txt |php randomGen.php

echo data/mmtrainSample.txt data/mtrainSample.txt data/mtestSample.txt data/hosts.txt data/tr_host.txt data/te_host.txt |php randomGen.php
#./svm_multiclass_learn -c 5000 example4/ntrainSample.txt example4/model
#./svm_multiclass_classify example4/ntestSample.txt example4/model example4/predictions >> log.tx
./medlda est 120 28 10 16 64 temp random >> log.txt
./medlda inf 28 temp120_*
echo data/mtestSample.txt data/te_host.txt data/m_tag_index.txt temp/predictions outdir/nprediction.txt outdir/wsf.txt |php predInterface.php  >> log.txt

#done

