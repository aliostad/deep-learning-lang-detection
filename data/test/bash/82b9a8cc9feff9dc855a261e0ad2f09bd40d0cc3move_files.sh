#!/usr/bin/env bash

<<DOC
Move files around leaving only geo submission files.
DOC

set -o nounset -o pipefail -o errexit -x

# Read variables from command line
sample=$(basename $1 .align.std.strand.pos.CPMs.bg)
output=$2

mv ${sample}*CPMs* etc/.
mv ${sample}*bam* etc/.
mv ${sample}*bw etc/.
mv ${sample}*umi* etc/.
mv ${sample}.align.std.strand.pos.counts.bg ${sample}.pos.bg
gzip ${sample}.pos.bg
mv ${sample}.align.std.strand.neg.counts.bg ${sample}.neg.bg
gzip ${sample}.neg.bg
mv ${sample}.*bg etc/.
echo 'done' > ${output}