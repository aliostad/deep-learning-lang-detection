#!/bin/bash
# This script produces the graphics needed in lab report

./2dimensionalComparison.py -l --save
#./2dimensionalComparison.py -c 'mwt/el_et>1.9' --save
#./2dimensionalComparison.py -p met:el_et --save
#./2dimensionalComparison.py -p met:el_et -l --save

./tauBackgroundEstimation.py -p mwt --save
./tauBackgroundEstimation.py -p met --cutline 30 --save
./tauBackgroundEstimation.py -p el_et -c 'met>30' --cutline 30 --save
./tauBackgroundEstimation.py -p mwt -c 'met>30&&el_et>30' --save
./tauBackgroundEstimation.py -p "mwt/el_et" --cutline 1.9 --save
echo "mycut:"
./tauBackgroundEstimation.py -p "mwt/el_et" -c "met>30&&el_et>30" --save
echo "mycut2:"
./tauBackgroundEstimation.py -p "mwt/el_et" -c "met>0&&el_et>0" --save
./analyse.py --save
./analyse.py --save -p "el_et"

./drawDifferentMCmasses.py

