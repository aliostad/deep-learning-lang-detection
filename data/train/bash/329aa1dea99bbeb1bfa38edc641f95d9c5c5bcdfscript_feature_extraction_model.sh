#!/bin/bash

for j in 0
do
for i in 2 
do
python feature_extraction_model.py budgetcalculator 1 $i 0.02 $j 1 1 -b
#python feature_extraction_model.py homeaffordability 1 $i 0.02 $j 1 1 -b
#python feature_extraction_model.py assetallocationcalculator 1 $i 0.02 $j 1 1 -b
#python feature_extraction_model.py careercalculator 1 $i 0.02 $j 1 1  -b

#python feature_extraction_model.py budgetcalculator 1 $i 0.05 $j 1  -b
#python feature_extraction_model.py homeaffordability 1 $i 0.05 $j 1  -b
#python feature_extraction_model.py assetallocationcalculator 1 $i 0.05 $j 1  -b
#python feature_extraction_model.py careercalculator 1 $i 0.05 $j 1  -b

#python feature_extraction_model.py budgetcalculator 1 $i 0.1 $j 1  -b
#python feature_extraction_model.py homeaffordability 1 $i 0.1 $j 1  -b
#python feature_extraction_model.py assetallocationcalculator 1 $i 0.1 $j 1  -b
#python feature_extraction_model.py careercalculator 1 $i 0.1 $j 1  -b

#python feature_extraction_model.py budgetcalculator 1 $i 0.15 $j 1  -b
#python feature_extraction_model.py homeaffordability 1 $i 0.15 $j 1  -b
#python feature_extraction_model.py assetallocationcalculator 1 $i 0.15 $j 1  -b
#python feature_extraction_model.py careercalculator 1 $i 0.15 $j 1  -b

done
done
