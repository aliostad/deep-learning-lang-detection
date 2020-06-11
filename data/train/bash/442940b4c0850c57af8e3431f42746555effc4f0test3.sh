#!/bin/bash 

SAMPLE="xxxxxx" #sample name 
OUTFOLD="../Output/" #output base folde, will save like ~/Output/m013126/. code does NOT create new folders and does not WARN. To be fixed.
BASEFOLD="../Input/"  #input base folder i.e. "~/TrainingData/CAI_itk_w2mhs/itk_data/out_mxxxx/"

SAMPLEFOLD=$BASEFOLD$SAMPLE"/"
MYFOLD=$OUTFOLD$SAMPLE"/"

cd ~/w2mhs-itk/build #location of executable
./w2mhs-itk -w $SAMPLEFOLD"WM_modstrip_"$SAMPLE".nii" -g $SAMPLEFOLD"GMCSF_strip_"$SAMPLE".nii" -v $SAMPLEFOLD"Vent_bin_"$SAMPLE".nii" -s $MYFOLD"WMHSeg_"$SAMPLE".nii" -q $MYFOLD"Results_"$SAMPLE".txt" -n 3 -d 1.5
