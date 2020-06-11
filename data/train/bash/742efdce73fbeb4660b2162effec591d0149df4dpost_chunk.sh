#!/bin/bash
#$ -q 1-day
#$ -cwd
#$ -l h_vmem=16G

source $BIN_PATH/job.config

PICARD="$JAVA -Xmx4g -jar $PICARD_JAR"

REF=$1
OUTPREFIX=$2
CHUNKFILE=$3

REFDICT=${REF/%fasta/dict}
REFDICT=${REFDICT/%fa/dict}
OUTDIR=$(dirname $OUTPREFIX)
OUT=$OUTDIR/somatic.5x.indel.vcf.gz
OUTMD5=$OUTDIR/checksum/$(basename $OUT).md5

for INTERVAL in $(cat $CHUNKFILE); do
    CHUNK=$OUTPREFIX.${INTERVAL/:/-}/somatic.5x.indel.vcf.gz
    CHUNKMD5=$(dirname $CHUNK)/checksum/$(basename $CHUNK).md5

    if [[ -f $CHUNK && -f $CHUNKMD5 ] && \
            $(md5sum $CHUNK|cut -f1 -d' ') = \
            $(cut -f1 -d' ' $CHUNKMD5) ]]; then
        tabix -f $CHUNK
    else
        echo "$CHUNK doesn't exist or doesn't match to the checksum."
        exit 1
    fi
done

$BCFTOOLS concat $OUTDIR/*/somatic.5x.indel.vcf.gz -O z -o $OUTDIR/temp.vcf.gz
$PICARD UpdateVcfSequenceDictionary SD=$REFDICT I=$OUTDIR/temp.vcf.gz O=$OUTDIR/temp2.vcf.gz
$PICARD SortVcf CREATE_INDEX=false I=$OUTDIR/temp2.vcf.gz O=$OUT

if [[ $? = 0 ]]; then
    mkdir -p $(dirname $OUTMD5)
    md5sum $OUT > $OUTMD5
    rm -f $OUTDIR/temp*.vcf.gz
fi
