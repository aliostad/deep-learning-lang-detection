#!/bin/bash
# usage: bash bootstrap_psmc.sh <sample>

set -u
set -e

HOME=/home/CIBIV/arun/
SW=${HOME}/software

sample="${1}"

#${SW}/psmc/utils/fq2psmcfa -q20 data/${sample}.fq.gz > data/${sample}.psmcfa
${SW}/psmc/utils/splitfa data/${sample}.psmcfa > data/${sample}.split.psmcfa
${SW}/psmc/psmc -N30 -t15 -r5 -p "32*2" -o results/${sample}.psmc data/${sample}.psmcfa
seq 100 | xargs -i echo ${SW}/psmc/psmc -N25 -t15 -r5 -b -p "32*2" \
	    -o results/bootstrap/${sample}.round-{}.psmc data/${sample}.split.psmcfa | sh
cat results/${sample}.psmc results/bootstrap/${sample}.round-*.psmc > results/${sample}.combined.psmc
#    utils/psmc_plot.pl -pY50000 combined combined.psmc