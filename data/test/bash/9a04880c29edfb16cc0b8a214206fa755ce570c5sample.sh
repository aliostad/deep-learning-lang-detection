#!/bin/sh

ABSDIR=$(cd $(dirname $0) && pwd)

echo "[sample] extract address data"
${ABSDIR}/../bin/extract_address_surface_tsv.pl ${ABSDIR}/../sample/13tokyo.csv > ${ABSDIR}/../sample/13tokyo.tsv

echo "[sample] make char unigram for address data"
${ABSDIR}/../bin/naive_make_chars_count_data.pl ${ABSDIR}/../sample/13tokyo.tsv 1 > ${ABSDIR}/../sample/char_unigram
echo "[sample] make char bigram for address data"
${ABSDIR}/../bin/naive_make_chars_count_data.pl ${ABSDIR}/../sample/13tokyo.tsv 2 > ${ABSDIR}/../sample/char_bigram

echo "[sample] make 3-fold cross validation data"
shuf ${ABSDIR}/../sample/13tokyo.tsv > ${ABSDIR}/../sample/13tokyo.tsv.shuf
split -nl/3 ${ABSDIR}/../sample/13tokyo.tsv.shuf

mv ${ABSDIR}/../xaa ${ABSDIR}/../sample/13tokyo.tsv.shuf.s01
mv ${ABSDIR}/../xab ${ABSDIR}/../sample/13tokyo.tsv.shuf.s02
mv ${ABSDIR}/../xac ${ABSDIR}/../sample/13tokyo.tsv.shuf.s03

echo "[sample] make char unigram for 3-fold cross validation data"
${ABSDIR}/../bin/naive_make_chars_count_data.pl ${ABSDIR}/../sample/13tokyo.tsv.shuf.s01 1 > ${ABSDIR}/../sample/13tokyo.tsv.shuf.s01.uni
${ABSDIR}/../bin/naive_make_chars_count_data.pl ${ABSDIR}/../sample/13tokyo.tsv.shuf.s02 1 > ${ABSDIR}/../sample/13tokyo.tsv.shuf.s02.uni
${ABSDIR}/../bin/naive_make_chars_count_data.pl ${ABSDIR}/../sample/13tokyo.tsv.shuf.s03 1 > ${ABSDIR}/../sample/13tokyo.tsv.shuf.s03.uni

echo "[sample] make char bigram for 3-fold cross validation data"
${ABSDIR}/../bin/naive_make_chars_count_data.pl ${ABSDIR}/../sample/13tokyo.tsv.shuf.s01 2 > ${ABSDIR}/../sample/13tokyo.tsv.shuf.s01.bi
${ABSDIR}/../bin/naive_make_chars_count_data.pl ${ABSDIR}/../sample/13tokyo.tsv.shuf.s02 2 > ${ABSDIR}/../sample/13tokyo.tsv.shuf.s02.bi
${ABSDIR}/../bin/naive_make_chars_count_data.pl ${ABSDIR}/../sample/13tokyo.tsv.shuf.s03 2 > ${ABSDIR}/../sample/13tokyo.tsv.shuf.s03.bi

echo "[sample] write config file of char unigram for 3-fold cross validation data"
echo ${ABSDIR}/../sample/13tokyo.tsv.shuf.s01.uni > ${ABSDIR}/../sample/config_unigram.txt
echo "\n" >> ${ABSDIR}/../sample/config_unigram.txt
echo ${ABSDIR}/../sample/13tokyo.tsv.shuf.s02.uni >> ${ABSDIR}/../sample/config_unigram.txt
echo"\n" >> ${ABSDIR}/../sample/config_unigram.txt
echo ${ABSDIR}/../sample/13tokyo.tsv.shuf.s03.uni >> ${ABSDIR}/../sample/config_unigram.txt
echo "\n" >> ${ABSDIR}/../sample/config_unigram.txt

echo "[sample] write config file of char bigram for 3-fold cross validation data"
echo ${ABSDIR}/../sample/13tokyo.tsv.shuf.s01.bi > ${ABSDIR}/../sample/config_bigram.txt
echo "\n" >> ${ABSDIR}/../sample/config_bigram.txt
echo ${ABSDIR}/../sample/13tokyo.tsv.shuf.s02.bi >> ${ABSDIR}/../sample/config_bigram.txt
echo "\n" >> ${ABSDIR}/../sample/config_bigram.txt
echo ${ABSDIR}/../sample/13tokyo.tsv.shuf.s03.bi >> ${ABSDIR}/../sample/config_bigram.txt
echo "\n" >> ${ABSDIR}/../sample/config_bigram.txt

echo "[sample] culc lambda parameter using char unigram for 3-fold cross validation data"
${ABSDIR}/../bin/naive_em_alporithm_for_average_lambda_estimate.pl ${ABSDIR}/../sample/config_unigram.txt 1
echo "[sample] culc lambda parameter using char bigram for 3-fold cross validation data"
${ABSDIR}/../bin/naive_em_alporithm_for_average_lambda_estimate.pl ${ABSDIR}/../sample/config_bigram.txt 2

echo "[sample] culc unigram only lm-score (lambda = 0.995901754065182)"
${ABSDIR}/../bin/naive_char_ngram_score_estimater.pl ${ABSDIR}/../sample/sample.txt ${ABSDIR}/../sample/char_unigram 1 0.995901754065182
echo "[sample] culc bigram only lm-score (lambda = 0.965973649703316)"
${ABSDIR}/../bin/naive_char_ngram_score_estimater.pl ${ABSDIR}/../sample/sample.txt ${ABSDIR}/../sample/char_bigram 2 0.965973649703316
