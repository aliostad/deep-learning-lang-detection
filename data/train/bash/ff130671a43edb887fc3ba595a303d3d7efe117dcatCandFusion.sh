#!/bin/bash

set -e -o pipefail

GFKDIR=$1
SHAREDDIR=$2
SAMPLE=$3
myrank=0

. $GFKDIR/common.sh


merge_files()
{
        ls ${SHAREDDIR}/countJunc.${SAMPLE}.*.txt |\
            xargs cat > countJunc.${SAMPLE}.txt
        ls ${SHAREDDIR}/junc2ID.${SAMPLE}.*.txt |\
            xargs cat > junc2ID.${SAMPLE}.txt
       #ls ${SHAREDDIR}/countJunc.${SAMPLE}.*.txt | xargs rm -f
       #ls ${SHAREDDIR}/junc2ID.${SAMPLE}.*.txt | xargs rm -f
}

parallel_region()
{
        {
        RUN ${GFKDIR}/intersectBed -a cj_tmp1.${SAMPLE}.bed -b ${SHAREDDIR}/gene.bed -wao > cj_gene1.${SAMPLE}.txt
        RUN_PERL ${GFKDIR}/makeJuncToGene.pl cj_gene1.${SAMPLE}.txt > junc2gene1.${SAMPLE}.txt
        } &

        if [ "$TIMEFORMAT1" != "" ]; then
                local TIMEFORMAT=$TIMEFORMAT1
        else
                local TIME=""
        fi
        {
        RUN ${GFKDIR}/intersectBed -a cj_tmp2.${SAMPLE}.bed -b ${SHAREDDIR}/gene.bed -wao > cj_gene2.${SAMPLE}.txt
        RUN_PERL ${GFKDIR}/makeJuncToGene.pl cj_gene2.${SAMPLE}.txt > junc2gene2.${SAMPLE}.txt
        } &

        if [ "$TIMEFORMAT2" != "" ]; then
                local TIMEFORMAT=$TIMEFORMAT2
        else
                local TIME=""
        fi
        {
        RUN ${GFKDIR}/intersectBed -a cj_tmp1.${SAMPLE}.bed -b cj_tmp2.${SAMPLE}.bed -wb > countJunc.inter.${SAMPLE}.txt
        RUN_PERL ${GFKDIR}/mergeJunc2.pl countJunc.inter.${SAMPLE}.txt > juncList.${SAMPLE}.txt
        } &

        wait
}


RUN merge_files

RUN_PERL ${GFKDIR}/makeBeds.pl countJunc.${SAMPLE}.txt cj_tmp1.${SAMPLE}.bed cj_tmp2.${SAMPLE}.bed

RUN parallel_region

RUN_PERL ${GFKDIR}/addAnno.pl juncList.${SAMPLE}.txt junc2gene1.${SAMPLE}.txt junc2gene2.${SAMPLE}.txt > juncList_anno0.${SAMPLE}.txt

RUN_PERL ${GFKDIR}/procEdge.pl juncList_anno0.${SAMPLE}.txt ${SHAREDDIR}/edge.bed > juncList_anno1.${SAMPLE}.txt

RUN_PERL ${GFKDIR}/filterByGene.pl juncList_anno1.${SAMPLE}.txt > juncList_anno2.${SAMPLE}.txt

RUN_PERL ${GFKDIR}/makeJuncBed.pl juncList_anno2.${SAMPLE}.txt > filtSeq.${SAMPLE}.bed

RUN ${GFKDIR}/fastaFromBed -fi ${SHAREDDIR}/hg19.fasta -bed filtSeq.${SAMPLE}.bed -fo filtSeq.${SAMPLE}.fasta -name -tab

RUN_PERL ${GFKDIR}/addSeq.pl juncList_anno2.${SAMPLE}.txt filtSeq.${SAMPLE}.fasta > juncList_anno3.${SAMPLE}.txt

RUN_PERL ${GFKDIR}/makePairBed.pl juncList_anno3.${SAMPLE}.txt > juncList_pair3.${SAMPLE}.txt

RUN ${GFKDIR}/pairToPair -a juncList_pair3.${SAMPLE}.txt -b ${SHAREDDIR}/chainSelf.bedpe -is > juncList_chainSelf.${SAMPLE}.bedpe

RUN_PERL ${GFKDIR}/addSelfChain.pl juncList_anno3.${SAMPLE}.txt juncList_chainSelf.${SAMPLE}.bedpe > juncList_anno4.${SAMPLE}.txt


# prepare for asssembly
# make the table for relationships between combinations of junctions and IDs
RUN_PERL ${GFKDIR}/makeComb2ID.pl juncList_anno4.${SAMPLE}.txt junc2ID.${SAMPLE}.txt > comb2ID.${SAMPLE}.txt

# add the data of reads aligned flanking the junctions
RUN_PERL ${GFKDIR}/addComb2ID.pl ${GFKDIR} ${SHAREDDIR}/GFKdedup.${SAMPLE}.bam comb2ID.${SAMPLE}.txt 20 $SAMPLE > ${SHAREDDIR}/comb2ID2.${SAMPLE}.txt
