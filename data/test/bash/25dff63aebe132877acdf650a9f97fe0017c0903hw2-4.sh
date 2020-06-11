#!/bin/sh

JAVA=/usr/local/versions/jdk-1.5.0_15/bin/java

IN=/usr/local/pub/mtf/pc1-20102/assignment2/pg100x20.txt
OUT=pg100x20.enc
CHUNK=65536

$JAVA EncryptFileSeq $IN $OUT $CHUNK
rm -rf $OUT
$JAVA -Dpj.nt=1 EncryptFileSmpNoOverlap $IN $OUT $CHUNK
rm -rf $OUT
$JAVA -Dpj.nt=2 EncryptFileSmpNoOverlap $IN $OUT $CHUNK
rm -rf $OUT
$JAVA -Dpj.nt=4 EncryptFileSmpNoOverlap $IN $OUT $CHUNK
rm -rf $OUT
$JAVA -Dpj.nt=8 EncryptFileSmpNoOverlap $IN $OUT $CHUNK
rm -rf $OUT

$JAVA -Dpj.nt=1 EncryptFileSmpOverlap $IN $OUT $CHUNK
rm -rf $OUT
$JAVA -Dpj.nt=2 EncryptFileSmpOverlap $IN $OUT $CHUNK
rm -rf $OUT
$JAVA -Dpj.nt=4 EncryptFileSmpOverlap $IN $OUT $CHUNK
rm -rf $OUT
$JAVA -Dpj.nt=8 EncryptFileSmpOverlap $IN $OUT $CHUNK
rm -rf $OUT
