#!/bin/bash

ITERATIONS=10000
RECALL_MODEL_ITERATIONS=1000
THIN=10

case "$1" in

1) echo  "Running mcmc recognition model version 1"
	Rscript mcmc_recognition_model_script.R v1 v1 'alpha.0,b,beta' 666 $ITERATIONS $THIN
   ;;

2) echo  "Running mcmc recognition model version 2"
	Rscript mcmc_recognition_model_script.R v2 v2 'alpha.0,b,beta' 667 $ITERATIONS $THIN
   ;;

3) echo  "Running mcmc recognition model version 3"
	Rscript mcmc_recognition_model_script.R v3 v3_v4 'alpha.0,b,beta' 1667 $ITERATIONS $THIN
   ;;

4) echo  "Running mcmc recognition model version 4"
	Rscript mcmc_recognition_model_script.R v4 v3_v4 'alpha.0,b,beta,gamma' 10667 $ITERATIONS $THIN
   ;;

5) echo  "Running mcmc recognition model version 5"
	Rscript mcmc_recognition_model_script.R v5 v5_v6 'alpha.0,b,beta,gamma' 11667 $ITERATIONS $THIN
   ;;

6) echo  "Running mcmc recognition model version 6"
	Rscript mcmc_recognition_model_script.R v6 v5_v6 'alpha.0,b,beta,gamma' 14667 $ITERATIONS $THIN
   ;;

7) echo  "Running mcmc recall model"
	Rscript mcmc_recall_model_script.R 'b' 1401 $RECALL_MODEL_ITERATIONS $THIN
   ;;

*) echo "There is no model $1. Type 1 to 7."
   ;;

esac
