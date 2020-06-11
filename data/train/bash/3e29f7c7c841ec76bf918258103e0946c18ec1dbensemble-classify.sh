#!/bin/bash

# Random forest
festclassify train-rf-0-5.data.model train-rf-0-5.data.model.predict &&
festclassify train-rf-1.data.model train-rf-1.data.model.predict &&
festclassify train-rf-2.data.model train-rf-2.data.model.predict &&
festclassify train-rf-4.data.model train-rf-4.data.model.predict && 
festclassify train-rf-8.data.model train-rf-8.data.model.predict &&
festclassify train-rf-16.data.model train-rf-16.data.model.predict &&
festclassify train-rf-32.data.model train-rf-32.data.model.predict &&
festclassify train-rf-64.data.model train-rf-64.data.model.predict 
# festclassify train-rf-0-5.data.model train-rf-0-5.data.model.predict
