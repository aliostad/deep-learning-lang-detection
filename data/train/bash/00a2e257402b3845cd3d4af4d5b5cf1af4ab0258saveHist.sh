#!/bin/bash

DOSAVE3PMC=0
DOSAVE3PData=1
DOSAVE5PMC=0
DOSAVE5PData=0


if [ $DOSAVE3PMC -eq 1 ]; then
sed '1ienum reaL{MC_MB,Data_MB,MC,Data}; reaL isData=MC;' saveHist3pMinpt.C > saveHist3pMinpt_MC_tmp.C
g++ saveHist3pMinpt_MC_tmp.C $(root-config --cflags --libs) -g -o saveHist3pMinpt_MC_tmp.exe 
./saveHist3pMinpt_MC_tmp.exe 
rm saveHist3pMinpt_MC_tmp.exe
rm saveHist3pMinpt_MC_tmp.C
fi

if [ $DOSAVE3PData -eq 1 ]; then
sed '1ienum reaL{MC_MB,Data_MB,MC,Data}; reaL isData=Data;' saveHist3pMinpt.C > saveHist3pMinpt_Data_tmp.C
g++ saveHist3pMinpt_Data_tmp.C $(root-config --cflags --libs) -g -o saveHist3pMinpt_Data_tmp.exe 
./saveHist3pMinpt_Data_tmp.exe 
rm saveHist3pMinpt_Data_tmp.exe
rm saveHist3pMinpt_Data_tmp.C
fi

if [ $DOSAVE5PMC -eq 1 ]; then
sed '1ienum reaL{MC_MB,Data_MB,MC,Data}; reaL isData=MC;' saveHist5pMinpt.C > saveHist5pMinpt_MC_tmp.C
g++ saveHist5pMinpt_MC_tmp.C $(root-config --cflags --libs) -g -o saveHist5pMinpt_MC_tmp.exe 
./saveHist5pMinpt_MC_tmp.exe 
rm saveHist5pMinpt_MC_tmp.exe
rm saveHist5pMinpt_MC_tmp.C
fi

if [ $DOSAVE5PData -eq 1 ]; then
sed '1ienum reaL{MC_MB,Data_MB,MC,Data}; reaL isData=Data;' saveHist5pMinpt.C > saveHist5pMinpt_Data_tmp.C
g++ saveHist5pMinpt_Data_tmp.C $(root-config --cflags --libs) -g -o saveHist5pMinpt_Data_tmp.exe 
./saveHist5pMinpt_Data_tmp.exe 
rm saveHist5pMinpt_Data_tmp.exe
rm saveHist5pMinpt_Data_tmp.C
fi