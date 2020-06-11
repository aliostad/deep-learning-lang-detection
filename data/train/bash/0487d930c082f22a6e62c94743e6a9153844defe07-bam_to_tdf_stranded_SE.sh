#!/bin/bash
set -e
set -x

###
#code to make it work on osx and linux
if
[[ $OSTYPE == darwin* ]]
then
readlink=$(which greadlink)
scriptdir="$(dirname $($readlink -f $0))"
else
scriptdir="$(dirname $(readlink -f $0))"
fi
#

###
#reference sequence directory variable - user should create a link called TAIR10_gen_chrc.chrom.sizes in script dir that points to the TAIR10_gen_chrc.genome.sizes file, or put a copy in there (chrc means we included all 7 chromosomes).

chrc_sizes=${scriptdir}/TAIR10_gen_chrc.chrom.sizes

sample=$1
alignFolder=$2
sample_dir=$alignFolder/$sample
outdir="tdf_for_igv/${sample}"
mkdir ${outdir}

#split F and R reads into plus and minus strand SE
#http://seqanswers.com/forums/showthread.php?t=29399

#R1 forward strand
samtools view -f 0 -b $sample_dir/$sample.bam   > $sample_dir/${sample}.forward.bam

#R1 reverse strand
samtools view -f 16 -b $sample_dir/$sample.bam   > $sample_dir/${sample}.reverse.bam

####################

echo "bam to bedgraph"
#non-stranded bedgraph
bedtools genomecov -bg -ibam $sample_dir/$sample.bam -g $chrc_sizes > $outdir/${sample}.bedgraph

#stranded bedgraphs - not using the '-strand +' flag because accounting for PE reads
#plus strand reads bedgraph
bedtools genomecov -bg -ibam $sample_dir/*reverse.bam -g $chrc_sizes > $outdir/${sample}.plus.bg
#minus strand reads bedgraph
bedtools genomecov -bg -scale -1 -ibam $sample_dir/*forward.bam -g $chrc_sizes > $outdir/${sample}.minus.bg

#make tdf
echo "bedgraph to binary tiled data (.tdf) file"
igvtools toTDF $outdir/*.bedgraph $outdir/$sample.tdf $chrc_sizes

#make bigWigs
echo "bam to bigWig"
bedGraphToBigWig $outdir/*.bedgraph $chrc_sizes $outdir/$sample.bigWig

bedGraphToBigWig $outdir/*.plus.bg $chrc_sizes $outdir/$sample.plus.bigWig
bedGraphToBigWig $outdir/*.minus.bg $chrc_sizes $outdir/$sample.minus.bigWig



