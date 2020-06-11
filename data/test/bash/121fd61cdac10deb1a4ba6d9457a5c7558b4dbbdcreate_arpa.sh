if [ $# -lt 3 ]; then
        echo "Usage: sh create_arpa.sh model-dir srilm gpu'n' "
        echo "eg: sh create_arpa.sh 2gram_param srilm.arap gpu0"
        exit
fi

model=$1
srilm=$2
gpu=$3 
mkdir $model/arpa 
echo "Creating all bigram data.." 
python scripts/arpa/CreateNgrams.py $model $model/arpa/allphrases
 

echo "calculating probabilities using NNLM..." 
sh scripts/run_test.sh $model/arpa/allphrases.2g.txt.id None $model $gpu $model/arpa/allphrases.2g.outprob 1 

#sh write_arpa.sh $model/param.babel.2g $model/allphrases.2g.txt.id $model/allphrases.2g.outprob 0 $test_size $P $model/voc.id #> test2.log 2>&1 & 
echo "Combining 1gram from SRILM and 2-grams from NNLM.." 
tail_size=`grep -n '2-grams' $srilm | cut -d ':' -f1`
head_size=`grep -n '1-grams' $srilm | cut -d ':' -f1`
head_size=`expr $head_size`
tail_size=`expr $tail_size - 2`
tot=`expr $tail_size - $head_size`
echo $head_size $tail_size $tot

cat $srilm | head -$tail_size | tail -$tot > $model/arpa/allphrases.1g.lm 
paste -d '\t'  $model/arpa/allphrases.2g.outprob $model/arpa/allphrases.2g.txt  > $model/arpa/allphrases.2g.lm
len1g=`wc $model/arpa/allphrases.1g.lm | awk '{print $1}'`
len2g=`wc $model/arpa/allphrases.2g.lm | awk '{print $1}'`
echo "Writing LM.."
python scripts/arpa/Create_ngram_lm.py $model/arpa/allphrases.1g.lm $len1g  $model/arpa/allphrases.2g.lm $len2g > $model/arpa/nnlm.arpa

#mkdir $model/arpa
#mv $model/allphrases.* $model/arpa/
#mv $model/nnlm.arpa $model/arpa/

#sh interpolate_arpa.sh $model $srilm data/dev.clean.txt 
#echo "Find best mix for SRILM and NNLM" 
#sh ~/tools/srilm/test_srilm.sh $srilm data/dev.clean.txt 3  > $model/srilm.ppl
#sh ~/tools/srilm/test_srilm.sh $model/nnlm.arpa data/dev.clean.txt 3 > $model/nnlm.arpa.ppl

#$SRILM/compute-best-mix $model/srilm.ppl $model/nnlm.arpa.ppl > $model/bestmix.log 2>&1 


