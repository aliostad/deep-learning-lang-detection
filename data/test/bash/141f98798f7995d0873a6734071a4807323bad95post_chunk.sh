#!/bin/bash
#$ -q 1-day
#$ -cwd

PREFIX=$1
CHUNKFILE=$2
MD5PREFIX=$(dirname $PREFIX)/checksum/$(basename $PREFIX)

# ==========================
# mutect filter KEEP & merge
# ==========================

OUT=$PREFIX.keep.txt
OUTMD5=$MD5PREFIX.keep.txt.md5
trap "rm -f $OUT" ERR

head -n2 $(ls $PREFIX.*.txt|head -n1) > $OUT
for INTERVAL in $(cat $CHUNKFILE); do
    CHUNK=$PREFIX.${INTERVAL/:/-}.txt
    CHUNKMD5=$MD5PREFIX.${INTERVAL/:/-}.txt.md5

    if [[ -f $CHUNK && -f $CHUNKMD5 && \
            $(md5sum $CHUNK|cut -f1 -d' ') = \
            $(cut -f1 -d' ' $CHUNKMD5) ]]; then
        tail -n+3 $CHUNK |grep KEEP$ |cat >> $OUT
    else
        echo "$CHUNK doesn't exist or doesn't match to the checksum."
        exit 1
    fi
done

# ====================================
# Create checksum & Remove chunk files
# ====================================

if [[ $? = 0 ]]; then
    md5sum $OUT > $OUTMD5
    rm -f $PREFIX.*-*-*.txt $MD5PREFIX.*-*-*.txt.md5
fi
