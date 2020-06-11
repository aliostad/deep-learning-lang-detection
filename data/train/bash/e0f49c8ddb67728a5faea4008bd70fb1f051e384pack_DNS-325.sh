#!/bin/sh

MODEL='DNS-325'
TEMPDIR='torrentmonitor'

#================================
echo "preparing files"
#make temporary directory
mkdir $TEMPDIR

#copy sources
echo "    copy source files"
cp -fr src/* $TEMPDIR

#copy model files
if [ -d $MODEL ] ; then
    echo "    copy files for $MODEL"
    cp -fr $MODEL/* $TEMPDIR
fi

#================================
echo "compiling addon"

#change dir
cd ./$TEMPDIR

#make addon
mkapkg -m $MODEL

#================================
echo "cleaning temporary files"

#remove temporary folder
rm -fr ../$TEMPDIR
