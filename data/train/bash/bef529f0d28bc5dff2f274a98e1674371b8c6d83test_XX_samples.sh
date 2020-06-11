#!/bin/sh

# load sample data

BASE=`dirname $0`

TS=$1
ES=$2
if [ ! "$TS" ]; then
	TS=dams
fi
if [ ! "$ES" ]; then
	ES=events
fi

# load sample objects
$BASE/ts-load.sh $TS $BASE/../sample/object

# load sample events
$BASE/ts-load.sh $ES $BASE/../sample/events

# post pdf
$BASE/fs-post-cmp.sh bb80808080 1 1.pdf $BASE/../sample/files/document.pdf

# generate derivatives
$BASE/fs-derivatives-cmp.sh bb80808080 1 1.pdf

# post jpg
$BASE/fs-post-cmp.sh bb80808080 2 1.jpg $BASE/../sample/files/image.jpg

# generate derivatives
$BASE/fs-derivatives-cmp.sh bb80808080 2 1.jpg

# simple image object with derivatives
$BASE/fs-post.sh bd22194583 1.jpg $BASE/../sample/files/image.jpg
$BASE/fs-derivatives.sh bd22194583 1.jpg

