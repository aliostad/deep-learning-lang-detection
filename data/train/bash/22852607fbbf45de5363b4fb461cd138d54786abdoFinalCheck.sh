#!/bin/bash

##Do SMS sorting and then combine the results of the different search regions..
model=T1tttt_madgraph_ucsb1776
#model=T5tttt
#model=T1t1t
#model=pMSSM_b1
#model=T1tttt_madgraph
#model=T1bbbb_madgraph
#model=T1bbbb
#model=T2tt

signal=1  #SMS
#signal=2   #pMSSM

echo Sorting through all search regions for the three sets of files for ${model}.
sleep 1

root -l -b -q 'SortSystematicFile.C("'btagEff_${model}_SIG.txt'",'${signal}')'
mv btagEff_${model}_SIG.txt.sorted btagEff_${model}_SIG.txt
mv btagEff_${model}_SIG.txt.original final_txt
root -l -b -q 'SortSystematicFile.C("'btagEff_${model}_LDP.txt'",'${signal}')'
mv btagEff_${model}_LDP.txt.sorted btagEff_${model}_LDP.txt
mv btagEff_${model}_LDP.txt.original final_txt
root -l -b -q 'SortSystematicFile.C("'btagEff_${model}_SL.txt'",'${signal}')'
mv btagEff_${model}_SL.txt.sorted btagEff_${model}_SL.txt
mv btagEff_${model}_SL.txt.original final_txt

root -l -b -q 'SortSystematicFile.C("'lightMistag_${model}_SIG.txt'",'${signal}')'
mv lightMistag_${model}_SIG.txt.sorted lightMistag_${model}_SIG.txt
mv lightMistag_${model}_SIG.txt.original final_txt
root -l -b -q 'SortSystematicFile.C("'lightMistag_${model}_LDP.txt'",'${signal}')'
mv lightMistag_${model}_LDP.txt.sorted lightMistag_${model}_LDP.txt
mv lightMistag_${model}_LDP.txt.original final_txt
root -l -b -q 'SortSystematicFile.C("'lightMistag_${model}_SL.txt'",'${signal}')'
mv lightMistag_${model}_SL.txt.sorted lightMistag_${model}_SL.txt
mv lightMistag_${model}_SL.txt.original final_txt

root -l -b -q 'SortSystematicFile.C("'rawCounts_${model}_SIG.txt'",'${signal}')'
mv rawCounts_${model}_SIG.txt.sorted rawCounts_${model}_SIG.txt
mv rawCounts_${model}_SIG.txt.original final_txt
root -l -b -q 'SortSystematicFile.C("'rawCounts_${model}_LDP.txt'",'${signal}')'
mv rawCounts_${model}_LDP.txt.sorted rawCounts_${model}_LDP.txt
mv rawCounts_${model}_LDP.txt.original final_txt
root -l -b -q 'SortSystematicFile.C("'rawCounts_${model}_SL.txt'",'${signal}')'
mv rawCounts_${model}_SL.txt.sorted rawCounts_${model}_SL.txt
mv rawCounts_${model}_SL.txt.original final_txt

echo Combining all search regions for the three sets of files.
sleep 1

if [  $signal -eq 1 ]
then
  root -l -b -q 'combine.C("'btagEff_${model}_SIG.txt'", "'btagEff_${model}_SL.txt'","'btagEff_${model}_LDP.txt'","''","'btagEff_${model}_SIG_SL_LDP.txt'")'
  root -l -b -q 'combine.C("'lightMistag_${model}_SIG.txt'", "'lightMistag_${model}_SL.txt'","'lightMistag_${model}_LDP.txt'","''","'lightMistag_${model}_SIG_SL_LDP.txt'")'
  root -l -b -q 'combine.C("'rawCounts_${model}_SIG.txt'", "'rawCounts_${model}_SL.txt'","'rawCounts_${model}_LDP.txt'","''","'rawCounts_${model}_SIG_SL_LDP.txt'")'
elif [  $signal -eq 2  ]
then
  root -l -b -q 'combine_pMSSM.C("'btagEff_${model}_SIG.txt'", "'btagEff_${model}_SL.txt'","'btagEff_${model}_LDP.txt'","''","'btagEff_${model}_SIG_SL_LDP.txt'")'
  root -l -b -q 'combine_pMSSM.C("'lightMistag_${model}_SIG.txt'", "'lightMistag_${model}_SL.txt'","'lightMistag_${model}_LDP.txt'","''","'lightMistag_${model}_SIG_SL_LDP.txt'")'
  root -l -b -q 'combine_pMSSM.C("'rawCounts_${model}_SIG.txt'", "'rawCounts_${model}_SL.txt'","'rawCounts_${model}_LDP.txt'","''","'rawCounts_${model}_SIG_SL_LDP.txt'")'
fi

exit

