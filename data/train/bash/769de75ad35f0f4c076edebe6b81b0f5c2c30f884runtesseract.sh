#!/bin/bash

cd ${TRAVIS_BUILD_DIR}

# rm below only for restarts
#rm ./tess4training-save/${LANG}layer_checkpoint 

lstmtraining \
  -U ./tess4training-save/${LANG}.unicharset \
  --script_dir ./tess4training-save \
  --append_index 5 --net_spec '[Lfx384 O1c105]' \
  --continue_from ./tess4training-save/${CONTINUE_FROM_LANG}.lstm \
  --train_listfile ./tess4training-save/${LANG}.training_files.txt \
  --eval_listfile ./tess4training-save/${LANG}.eval_files.txt \
  --model_output ./tess4training-save/${LANG}layer \
  --debug_interval 0 \
  --perfect_sample_delay 19 \
  --max_iterations ${MAX_ITERATIONS}

lstmtraining   \
  --continue_from ./tess4training-save/${LANG}layer_checkpoint  \
  --model_output ./tess4training-save/${NEWLANG}.lstm  \
  --stop_training 
  
combine_tessdata   ./tess4training-save/${NEWLANG}.
sudo mv ./tess4training-save/${NEWLANG}.traineddata /usr/share/tesseract-ocr/4.00/tessdata/${NEWLANG}.traineddata

echo "${NEWLANG} traineddata from current training"
time tesseract ./${TESTFILE}.tif ${TESTFILE}-${NEWLANG} --oem 1 --psm 6 -l ${NEWLANG} 
echo "${LANG} traineddata from tessdata repo"
time tesseract ./${TESTFILE}.tif ${TESTFILE}-${LANG} --oem 1 --psm 6 -l ${LANG} 

ls  -l ./tess4training-save/*.lstm
rm ./tess4training-save/${LANG}layer*.lstm
rm ./tess4training-save/${NEWLANG}.lstm

git tag -a V.$TRAVIS_BUILD_NUMBER -m "travis build $TRAVIS_BUILD_NUMBER "
