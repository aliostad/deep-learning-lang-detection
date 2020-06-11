#!/bin/bash
for i in {0..9}
do
  echo "Generating $i.hmm and $i.trans"
  python train_hmm_mod.py $i
done

#dirname='model_euclidean_withconst_cov'
#dirname='model_mahalanobis_withconst_cov'
#dirname='model_euclidean_withoutconst_cov'
#dirname='model_mahalanobis_withoutconst_cov'
#dirname='model_euclidean_withconst_corrcoef'
#dirname='model_mahalanobis_withconst_corrcoef'
#dirname='model_euclidean_withoutconst_corrcoef'
dirname='model_mahalanobis_withoutconst_ccorrcoef'

mkdir ../$dirname
cp *.hmm *.trans ../$dirname/
