#!/bin/bash

TMP_FILE=tmp.smali

OLD_IFS=$IFS
for f in `grep  -rn "IccCard;->" $1 | grep "invoke-virtual" | cut -d: -f1 | uniq | sort`
do
    echo "replace file:$f"
    cat /dev/null > $TMP_FILE
    IFS=$'\n'
    for l in `cat $f`
    do
        echo $l | grep  "IccCard;->" | grep "invoke-virtual" -q
        if [ $? -eq 0 ]
        then
           l=`echo $l | sed "s/invoke-virtual/invoke-interface/"`
        fi
        echo $l >> $TMP_FILE
    done
    cp $TMP_FILE $f
done
if [ -f $TMP_FILE ]
then 
    rm $TMP_FILE
fi
IFS=$OLD_IFS

for f in `grep -rn "IccCard;->registerForNetworkLocked(" $1 | cut -d: -f1 | uniq | sort`
do
    echo "replace file:$f"
    sed "s/IccCard;->registerForNetworkLocked(/IccCard;->registerForPersoLocked(/g" $f > $TMP_FILE
    cp $TMP_FILE $f
    rm $TMP_FILE
done

for f in `grep -rn "IccCardApplication\$AppType;" $1 | cut -d: -f1 | uniq | sort`
do
    echo "replace file:$f"
    sed "s/IccCardApplication\$AppType;/IccCardApplicationStatus\$AppType;/g" $f > $TMP_FILE
    cp $TMP_FILE $f
    rm $TMP_FILE
done
