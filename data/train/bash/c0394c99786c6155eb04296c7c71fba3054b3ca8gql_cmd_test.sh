#!/bin/bash

VERBOSE=$1

A=../data/tiny_a.bed
B=../data/tiny_b.bed
C=../data/tiny_c.bed
D=../data/tiny_d.bed

L=../data/tiny_*.bed

TMP=.tmp.gql

GQL=../gql.py

function run_test {
	echo $1
	echo $2 > $TMP
	$GQL $TMP > $TMP.out
	E=$?
	if [ $E -ne $3 ]
	then
		cat $TMP.out
	elif [ $4 -eq 1 ]
	then
		cat $TMP 
		cat $TMP.out
	fi
	rm $TMP
	rm $TMP.out
}

run_test "1 ::: LOAD, PRINT" \
	"a = LOAD \"$A\";PRINT a;" \
	0 \
	$VERBOSE

run_test "2 ::: LOAD AS, COUNT"  \
	"a = LOAD \"$A\" AS BED6;PRINT a;c=COUNT a;PRINT c;" \
	0 \
	$VERBOSE

run_test "3 ::: Wrong file type on LOAD" "a = LOAD \"$A\" AS BED3;" \
	0 \
	$VERBOSE
run_test "4 ::: Wrong file type on LOAD" "a = LOAD \"$A\" AS BED12;" \
	0 \
	$VERBOSE

run_test "5 ::: Binary INTERSECT, COUNT BEDM" \
	"a = LOAD \"$A\";
	b = LOAD \"$B\";
	c = LOAD \"$C\";
	d = LOAD \"$D\";
	e = a,b INTERSECT a,b,c,d;
	PRINT e;
	f=COUNT e;
	PRINT f;" \
	0 \
	$VERBOSE

run_test "6 ::: Unary INTERSECT, COUNT BEDN" \
	"a = LOAD \"$A\";
	b = LOAD \"$B\";
	c = LOAD \"$C\";
	d = LOAD \"$D\";
	e = INTERSECT a,b,c,d;
	PRINT e;
	f=COUNT e;
	PRINT f;" \
	0 \
	$VERBOSE

run_test "7 ::: SUBTRACT" \
	"a = LOAD \"$A\";
	b = LOAD \"$B\";
	c = LOAD \"$C\";
	e = a SUBTRACT b,c;
	PRINT e;
	f =COUNT e;
	PRINT f;" \
	0 \
	$VERBOSE

run_test "8 ::: MERGEMAX" \
	"a = LOAD \"$A\";
	b = LOAD \"$B\";
	e = MERGEMAX  a,b;
	PRINT e;
	f =COUNT e;
	PRINT f;" \
	0 \
	$VERBOSE

run_test "9 ::: MERGEMAX, SCORE,SUM" \
	"a = LOAD \"$A\";
	b = LOAD \"$B\";
	e = MERGEMAX a,b WHERE SCORE(SUM);
	PRINT e;
	f = COUNT e;
	PRINT f;" \
	0 \
	$VERBOSE

run_test "10 ::: MERGEMAX, SCORE, MEDIAN" \
	"a = LOAD \"$A\";
	b = LOAD \"$B\";
	e = MERGEMAX a,b WHERE SCORE(MEDIAN);
	PRINT e;
	f=COUNT e;
	PRINT f;" \
	0 \
	$VERBOSE

run_test "11 ::: MERGEMAX, SCORE, MIN" \
	"a = LOAD \"$A\";
	b = LOAD \"$B\";
	e = MERGEMAX a,b WHERE SCORE(MIN);
	PRINT e;
	f = COUNT e;
	PRINT f;" \
	0 \
	$VERBOSE

run_test "12 ::: MERGEMAX, SCORE, MAX" \
	"a = LOAD \"$A\";
	b = LOAD \"$B\";
	c = LOAD \"$C\";
	e = MERGEMAX a,b,c WHERE SCORE(MAX);
	PRINT e;
	f=COUNT e;
	PRINT f;" \
	0 \
	$VERBOSE

run_test "14 ::: MERGEMAX, SCORE, COUNT" \
	"a = LOAD \"$A\";
	b = LOAD \"$B\";
	c = LOAD \"$C\";
	e = MERGEMAX a,b,c WHERE SCORE(COUNT);
	PRINT e;" \
	0 \
	$VERBOSE

run_test "15 ::: MERGEMAX, NAME, SCORE, COUNT" \
	"a = LOAD \"$A\";
	b = LOAD \"$B\";
	c = LOAD \"$C\";
	e = MERGEMAX a,b,c WHERE NAME(COLLAPSE),SCORE(COUNT);
	PRINT e;" \
	0 \
	$VERBOSE

run_test "16 ::: MERGEFLAT, NAME, SCORE, COUNT" \
	"a = LOAD \"$A\";
	b = LOAD \"$B\";
	c = LOAD \"$C\";
	e = MERGEFLAT a,b,c WHERE NAME(COLLAPSE),SCORE(COUNT);
	PRINT e;" \
	0 \
	$VERBOSE

run_test "17 ::: MERGEMIN, NAME, SCORE, COUNT" \
	"a = LOAD \"$A\";
	b = LOAD \"$B\";
	c = LOAD \"$C\";
	e = MERGEMIN a,b,c WHERE NAME(COLLAPSE),SCORE(COUNT);
	PRINT e;" \
	0 \
	$VERBOSE

run_test "18 ::: LOAD dir, COUNT, PRINT"\
	"a = LOAD \"$L\";
	b=COUNT a;
	PRINT b;
	PRINT a;" \
	0 \
	$VERBOSE

run_test "19 ::: LOAD dir, Binary INTERSECT, PRINT, COUNT "\
	"a = LOAD \"$L\";
	 b = LOAD \"$B\";
	 c = b INTERSECT a;
	PRINT c;
	d=COUNT c;
	PRINT d;" \
	0 \
	$VERBOSE

run_test "20 ::: LOAD dir, Unary INTERSECT, PRINT" \
	"a = LOAD \"$L\";
	e = INTERSECT a;
	PRINT e;
	f = COUNT e;
	PRINT f;" \
	0 \
	$VERBOSE


run_test "21 ::: MERGEMAX, SCORE,SUM" \
	"a = LOAD \"$L\";
	e = MERGEMAX a WHERE NAME(COLLAPSE),SCORE(SUM);
	PRINT e;
	f = COUNT e;
	PRINT f;" \
	0 \
	$VERBOSE
