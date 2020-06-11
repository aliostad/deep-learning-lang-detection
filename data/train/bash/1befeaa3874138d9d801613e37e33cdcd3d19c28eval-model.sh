#! /bin/bash

. ../set-env.sh

../sentence-alignment/sent-segment.scala ../corpus/shiji/shiji.dev.modern model-input.dev.tmp
sed -i "s/<p>//" model-input.dev.tmp
../tokenization/tokenize.scala --vocab ../learn-vocabulary/shiji-vocab crf model-input.dev.tmp model-input.dev

../sentence-alignment/sent-segment.scala ../corpus/shiji/shiji.test.modern model-input.test.tmp
sed -i "s/<p>//" model-input.test.tmp
../tokenization/tokenize.scala --vocab ../learn-vocabulary/shiji-vocab crf model-input.test.tmp model-input.test

#moses -threads 4 -f ../train/model/moses.ini < model-input.dev > model-output.dev.tmp
moses -threads 4 -f ../tune/mert-work/moses.ini < model-input.dev > model-output.dev.tmp
sed -i "s/ //g" model-output.dev.tmp
perl -00pe 's/\n(?!\n)//gs' model-output.dev.tmp > model-output.dev

#moses -threads 4 -f ../train/model/moses.ini < model-input.test > model-output.test.tmp
moses -threads 4 -f ../tune/mert-work/moses.ini < model-input.test > model-output.test.tmp
sed -i "s/ //g" model-output.test.tmp
perl -00pe 's/\n(?!\n)//gs' model-output.test.tmp > model-output.test

echo "Evaluating dev result:"
./bleu-eval.scala ../corpus/shiji/shiji.dev.classical model-output.dev

echo "Evaluating test result:"
./bleu-eval.scala ../corpus/shiji/shiji.test.classical model-output.test
