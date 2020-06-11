#!/bin/bash

outfile="result.txt"
samplepath="./sample"
resultpaht="./result"

`rm $resultpaht/$outfile`

`./Bayes_classifier.sh $samplepath/sample_B1 $resultpaht/$outfile`
`./Bayes_classifier.sh $samplepath/sample_B2 $resultpaht/$outfile`
`./Bayes_classifier.sh $samplepath/sample_B3 $resultpaht/$outfile`
`./Bayes_classifier.sh $samplepath/sample_B4 $resultpaht/$outfile`
`./Bayes_classifier.sh $samplepath/sample_B5 $resultpaht/$outfile`
`./Bayes_classifier.sh $samplepath/sample_B6 $resultpaht/$outfile`
`./Bayes_classifier.sh $samplepath/sample_B7 $resultpaht/$outfile`
`./Bayes_classifier.sh $samplepath/sample_B8 $resultpaht/$outfile`
`./Bayes_classifier.sh $samplepath/sample_B9 $resultpaht/$outfile`
`./Bayes_classifier.sh $samplepath/sample_B10 $resultpaht/$outfile`

