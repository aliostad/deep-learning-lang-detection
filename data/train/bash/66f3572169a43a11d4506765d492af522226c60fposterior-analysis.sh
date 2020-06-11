#!/bin/sh

# estimated values
T=0.0038895999511
C=464.480277797
R=0.212495205026

for chunk in {0..9};
do
    python ../scripts/posterior-from-I-model.py -T $T -C $C -R $R analysis/sim_I_${chunk}.ziphmm | \
	python ../scripts/marginal-posterior.py > marginal-posterior-${chunk}-estimated.txt
done

# simulated values
T=0.004
C=500
R=0.4

for chunk in {0..9};
do
    python ../scripts/posterior-from-I-model.py -T $T -C $C -R $R analysis/sim_I_${chunk}.ziphmm | \
	python ../scripts/marginal-posterior.py > marginal-posterior-${chunk}-simulated.txt
done

