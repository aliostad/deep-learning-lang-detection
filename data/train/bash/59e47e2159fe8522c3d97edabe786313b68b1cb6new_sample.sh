#!/bin/bash
#load path from .bash_profile
source /home/arun/.bashrc

SAMPLE=$1
cp ./LV-89-02-trimmed-unmapped.sh ./temp.$SAMPLE.sh
sed s/sample\=\'LV-89-02-trimmed-unmapped\'/sample\=\'$SAMPLE\'/ <temp.$SAMPLE.sh >$SAMPLE.sh
rm temp.$SAMPLE.sh
if [ ! -f ../data/virus-names/$SAMPLE.txt ]; then
    cp ../data/virus-names/LV-89-02-trimmed-unmapped.txt ../data/virus-names/$SAMPLE.txt
fi
mkdir ../temp/$SAMPLE
mkdir ../results/$SAMPLE/
mkdir ../results/$SAMPLE/blast ../results/$SAMPLE/contigs ../results/$SAMPLE/coverage ../results/$SAMPLE/reads

echo "Files created. Be sure to change the names of the viruses you're looking for in ../data/virus-names/"$SAMPLE
