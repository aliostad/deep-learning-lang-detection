#!/bin/sh

export name="case_control"

# allelic test
plink --bfile $name --assoc --out allelic

# logistic regression
plink --bfile $name --logistic --out logistic

# ALLELIC, TREND, GENO, DOM or REC
plink --bfile $name --model --out model
head -n1 model.model > model.header
cat model.model | grep "GENO"  > tmp; cat model.header tmp > model.geno
cat model.model | grep "TREND" > tmp; cat model.header tmp > model.trend
cat model.model | grep "DOM"   > tmp; cat model.header tmp > model.dom
cat model.model | grep "REC"   > tmp; cat model.header tmp > model.rec













# ##################################################
## load data in R
#R
#d = read.table("sim1.raw", header=T)
#X = as.matrix(d[,-seq(1, 6)])  # genotype matrix
