#!/bin/bash --login
module load SAMtools

sample=$1
INDIR=/work/projects/melanomics/analysis/genome/$sample/bam/
OUTDIR=/work/projects/melanomics/analysis/genome/$sample/unmapped
mkdir -pv $OUTDIR
input=$INDIR/$sample.bam
output=$OUTDIR/$sample.unmapped.paired.bam
stderr=${output%bam}stderr
stdout=${output%bam}stdout

# oarsub -l/nodes=1/core=2,walltime=72 -O $stdout -E $stderr -n ${sample}_unmap "date; time samtools view -hf1 $input | samtools view -hSf4 - | samtools view -bhSf8 - > $output; date"


output=$OUTDIR/$sample.unmapped.singleton.bam
stderr=${output%bam}stderr
stdout=${output%bam}stdout
# oarsub -l/nodes=1/core=2,walltime=72 -O $stdout -E $stderr -n ${sample}_unmap "date; time samtools view -hF1 $input | samtools view -bhSf4 - > $output; date"

input1=$OUTDIR/$sample.unmapped.paired.bam
input2=$OUTDIR/$sample.unmapped.singleton.bam
output=$OUTDIR/$sample.unmapped.bam
stderr=${output%bam}stderr
stdout=${output%bam}stdout
oarsub -l/nodes=1/core=2,walltime=72 -O $stdout -E $stderr -n ${sample}_unmap "date; time samtools merge $output $input1 $input2; date "





