#!/bin/bash

outfile="result.txt"
samplepath="./sample"
resultpaht="./result"

`rm $resultpaht/$outfile`

`./Bayes_classifier.sh $samplepath/sample_A1 $resultpaht/$outfile`
`./Bayes_classifier.sh $samplepath/sample_A2 $resultpaht/$outfile`
`./Bayes_classifier.sh $samplepath/sample_A3 $resultpaht/$outfile`
`./Bayes_classifier.sh $samplepath/sample_A4 $resultpaht/$outfile`
`./Bayes_classifier.sh $samplepath/sample_A5 $resultpaht/$outfile`
`./Bayes_classifier.sh $samplepath/sample_A6 $resultpaht/$outfile`
`./Bayes_classifier.sh $samplepath/sample_A7 $resultpaht/$outfile`
`./Bayes_classifier.sh $samplepath/sample_A8 $resultpaht/$outfile`
`./Bayes_classifier.sh $samplepath/sample_A9 $resultpaht/$outfile`
`./Bayes_classifier.sh $samplepath/sample_A10 $resultpaht/$outfile`

