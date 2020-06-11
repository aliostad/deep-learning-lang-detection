#!/bin/bash -l

set -e
set -u
set -o pipefail

CIS_WINDOW=0
CHUNKS=3

TMPD=`mktemp -d`
trap "rm -rf ${TMPD}" EXIT

../table-sort-genomic < data/genespos.ex1.tab \
    | ../data-cis-ranges \
    <(../table-sort-genomic < data/snpspos.ex1.tab) \
    ${CIS_WINDOW} \
    > ${TMPD}/cisRanges.tab \
    2> /dev/null

../cis-ranges-chunks --mode=gex --chunks=${CHUNKS} \
  < ${TMPD}/cisRanges.tab \
  > ${TMPD}/cisChunks.tab \
  2> /dev/null

../data-cis-split \
  --pos-gex=data/genespos.ex1.tab \
  --pos-gt=data/snpspos.ex1.tab \
  --cis-ranges=${TMPD}/cisRanges.tab \
  --chunks=${TMPD}/cisChunks.tab \
  --output-prefix="${TMPD}/chunks/" \
  --dump-cisranges \
  2> /dev/null \
  > /dev/null

for chunk in `ls ${TMPD}/chunks` ; do
  ../cis-ranges-to-pairs \
    <(cut -f 1 ${TMPD}/chunks/${chunk}/genotype.pos) \
    < ${TMPD}/chunks/${chunk}/cisRanges.tab \
    > ${TMPD}/chunks/${chunk}/cisPairs.tab \
    2> /dev/null
done

for chunk in `ls ${TMPD}/chunks` ; do
  cut -f 1 ${TMPD}/chunks/${chunk}/expression.pos | sort | uniq > ${TMPD}/chunks/${chunk}/reporterIDs.pos.txt
  cut -f 1 ${TMPD}/chunks/${chunk}/cisPairs.tab | sort | uniq > ${TMPD}/chunks/${chunk}/reporterIDs.cisPairs.txt
  if ! comm -23 ${TMPD}/chunks/${chunk}/reporterIDs.{cisPairs,pos}.txt > /dev/null ; then
    echo "inconsistent expression annotation results in chunk ${chunk}:"
    comm -23 ${TMPD}/chunks/${chunk}/reporterIDs.{cisPairs,pos}.txt
    exit 1
  fi

  cut -f 1 ${TMPD}/chunks/${chunk}/genotype.pos | sort | uniq > ${TMPD}/chunks/${chunk}/SNPIDs.pos.txt
  cut -f 2 ${TMPD}/chunks/${chunk}/cisPairs.tab | sort | uniq > ${TMPD}/chunks/${chunk}/SNPIDs.cisPairs.txt
  if ! comm -23 ${TMPD}/chunks/${chunk}/SNPIDs.{cisPairs,pos}.txt > /dev/null ; then
    echo "inconsistent genotype annotation results in chunk ${chunk}:"
    comm -23 ${TMPD}/chunks/${chunk}/SNPIDs.{cisPairs,pos}.txt
    exit 1
  fi
done

cat ${TMPD}/chunks/*/cisPairs.tab | sort > ${TMPD}/cisPairs.splitted.tab

../cis-ranges-to-pairs \
  <(cut -f 1 data/snpspos.ex1.tab) \
  < ${TMPD}/cisRanges.tab \
  > ${TMPD}/cisPairs.full.tab \
  2> /dev/null

if diff ${TMPD}/cisPairs.{full,splitted}.tab > /dev/null ; then
  echo "splitting cis-ranges behaves consistently"
else
  diff ${TMPD}/cisPairs.{full,splitted}.tab
fi
