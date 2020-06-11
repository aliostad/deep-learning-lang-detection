#!/bin/bash

NAME=Run2011A_05Aug2011_v1
DIR=crab_0_120918_115134/res

#--------------
TMP=Tmp
ALL=All
SAMPLE=Sample
TRAIN=Train
LIST=.list

M=$(wc -l < $ALL/$NAME"_"$TMP$LIST)
echo "M = $M"

RESTO=$(expr $M % 2)
echo "RESTO = $RESTO"

if [ "$RESTO" -eq 0 ]; then
	N=$(expr $M / 2)
	echo "N = $N"
else
	N=$(expr $(expr $M - 1) / 2)
	echo "N = $N"
fi

#All
touch $ALL/$NAME"_"$ALL$LIST
rm $ALL/$NAME"_"$ALL$LIST
touch $ALL/$NAME"_"$ALL$LIST
for ((i=1;i<=$M;i++)); do
	LINE_ALL=$(cat $ALL/$NAME"_"$TMP$LIST | grep "Ele_$i"_"")
	echo $LINE_ALL >> $ALL/$NAME"_"$ALL$LIST
done;

#Sample
touch $TRAIN/$NAME"_"$TRAIN$LIST
rm $TRAIN/$NAME"_"$TRAIN$LIST
touch $TRAIN/$NAME"_"$TRAIN$LIST
for ((i=1;i<=$N;i++)); do
	rm "$SAMPLE/$DIR/CMSSW_$i.stdout"
	rm "$SAMPLE/$DIR/CMSSW_$i.stderr"
	rm "$SAMPLE/$DIR/Watchdog_$i.log.gz"
	rm "$SAMPLE/$DIR/crab_fjr_$i.xml"
	LINE_TRAIN=$(cat $ALL/$NAME"_"$ALL$LIST | grep "Ele_$i"_"")
	echo $LINE_TRAIN >> $TRAIN/$NAME"_"$TRAIN$LIST
done;

#Train
touch $SAMPLE/$NAME"_"$SAMPLE$LIST
rm $SAMPLE/$NAME"_"$SAMPLE$LIST
touch $SAMPLE/$NAME"_"$SAMPLE$LIST
for ((i=$(expr $N + 1);i<=$M;i++)); do
	rm "$TRAIN/$DIR/CMSSW_$i.stdout"
	rm "$TRAIN/$DIR/CMSSW_$i.stderr"
	rm "$TRAIN/$DIR/Watchdog_$i.log.gz"
	rm "$TRAIN/$DIR/crab_fjr_$i.xml"
	LINE_SAMPLE=$(cat $ALL/$NAME"_"$ALL$LIST | grep "Ele_$i"_"")
	echo $LINE_SAMPLE >> $SAMPLE/$NAME"_"$SAMPLE$LIST
done;
