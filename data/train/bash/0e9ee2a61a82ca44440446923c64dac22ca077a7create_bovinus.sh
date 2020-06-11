#!/bin/bash

SCRIPTDIR=`dirname $0`
ROOTDIR="$SCRIPTDIR/.."
OUTFILE=bovinus_all_$$.js
COMPRESS=""

while getopts co: option
do
    case $option in
	c)
	COMPRESS="X";;
	o)
	OUTFILE=$OPTARG;;
    esac
done

function append() {
    
    filename=$1
    
    echo " " >> $OUTFILE
    echo "/*" >> $OUTFILE
    echo " * ===== $filename =====" >> $OUTFILE
    echo " */" >> $OUTFILE
    echo " " >> $OUTFILE
	# Append source file, remove 17 comment lines on top of each file
    sed "1,17 d" < $ROOTDIR/$filename > tmp$$
	cat tmp$$ >> $OUTFILE

}

rm -f $OUTFILE
touch tmp$$
cat $SCRIPTDIR/license_comment.txt > $OUTFILE
append ooptimus/ooptimus.js
append bovinus/bovinus.js
append bovinus/util.js
append bovinus/token.js
append bovinus/tokenizer.js
append bovinus/instream.js
append bovinus/input_buffer.js
append bovinus/lexer.js
append bovinus/grammar.js
append bovinus/context.js
append bovinus/ast.js
append bovinus/path.js
append bovinus/parser.js
rm -f tmp$$

if [ "$COMPRESS" == "X" ]; then
    tmp=tmp$$
    java -jar $ROOTDIR/external-tools/yuicompressor-2.4.7.jar $OUTFILE -o $tmp
    rm $OUTFILE
    mv $tmp $OUTFILE
fi
