#!/usr/bin/env bash
#BSUB -J umi_length_testing
#BSUB -e umi_length_testing.%J.err
#BSUB -o umi_length_testing.%J.out
#BSUB -q normal
#BSUB -R "select[mem>10] rusage[mem=10] span[hosts=1]"
#BSUB -n 1
#BSUB -P kabos

<<DOC
trim fastq, compensating for longer UMI. compare alignment results.
DOC

set -o nounset -o pipefail -o errexit -x
source $HOME/projects/polya/bin/config.sh

sample=PK111
bin=$HOME/devel/umitools
unprocessed_fastq=$DATA/$sample.fq.gz

# trimming extra
umi1=$sample.7bp.fq.gz
umi2=$sample.8bp.fq.gz
umi3=$sample.9bp.fq.gz
umi4=$sample.10bp.fq.gz
umi5=$sample.11bp.fq.gz

umi1bam=$sample.7bp.bam
umi2bam=$sample.8bp.bam
umi3bam=$sample.9bp.bam
umi4bam=$sample.10bp.bam
umi5bam=$sample.11bp.bam

stats1=$sample.7bp.txt
stats2=$sample.8bp.txt
stats3=$sample.9bp.txt
stats4=$sample.10bp.txt
stats5=$sample.11bp.txt

# trim the UMI
bsub -J prepend_umi -o $sample.7bp.trim.out -e $sample.7bp.trim.err -P $PROJECTID -K "python $bin/umitools.py trim --verbose $unprocessed_fastq NNNNNNN | gzip -c > $umi1" &
bsub -J prepend_umi -o $sample.8bp.trim.out -e $sample.8bp.trim.err -P $PROJECTID -K "python $bin/umitools.py trim --verbose $unprocessed_fastq NNNNNNNN | gzip -c > $umi2" &
bsub -J prepend_umi -o $sample.9bp.trim.out -e $sample.9bp.trim.err -P $PROJECTID -K "python $bin/umitools.py trim --verbose $unprocessed_fastq NNNNNNNNN | gzip -c > $umi3" &
bsub -J prepend_umi -o $sample.10bp.trim.out -e $sample.10bp.trim.err -P $PROJECTID -K "python $bin/umitools.py trim --verbose $unprocessed_fastq NNNNNNNNNN | gzip -c > $umi4" &
bsub -J prepend_umi -o $sample.11bp.trim.out -e $sample.11bp.trim.err -P $PROJECTID -K "python $bin/umitools.py trim --verbose $unprocessed_fastq NNNNNNNNNNN | gzip -c > $umi5" &

wait

bsub -J align -o $sample.7bp.map.out -e $sample.7bp.map.err -P $PROJECTID -K -R "select[mem>10] rusage[mem=10] span[hosts=1]" -n 8 "novoalign -d $NOVOIDX -f $umi1 -o SAM -n 50 -r None -c 8 -k 2> $stats1 | samtools view -ShuF4 - | samtools sort -o - $sample.7bp.temp -m 8G > $umi1bam"
bsub -J align -o $sample.8bp.map.out -e $sample.8bp.map.err -P $PROJECTID -K -R "select[mem>10] rusage[mem=10] span[hosts=1]" -n 8 "novoalign -d $NOVOIDX -f $umi2 -o SAM -n 50 -r None -c 8 -k 2> $stats2 | samtools view -ShuF4 - | samtools sort -o - $sample.8bp.temp -m 8G > $umi2bam"
bsub -J align -o $sample.9bp.map.out -e $sample.9bp.map.err -P $PROJECTID -K -R "select[mem>10] rusage[mem=10] span[hosts=1]" -n 8 "novoalign -d $NOVOIDX -f $umi3 -o SAM -n 50 -r None -c 8 -k 2> $stats3 | samtools view -ShuF4 - | samtools sort -o - $sample.9bp.temp -m 8G > $umi3bam"
bsub -J align -o $sample.10bp.map.out -e $sample.10bp.map.err -P $PROJECTID -K -R "select[mem>10] rusage[mem=10] span[hosts=1]" -n 8 "novoalign -d $NOVOIDX -f $umi4 -o SAM -n 50 -r None -c 8 -k 2> $stats4 | samtools view -ShuF4 - | samtools sort -o - $sample.10bp.temp -m 8G > $umi4bam"
bsub -J align -o $sample.11bp.map.out -e $sample.11bp.map.err -P $PROJECTID -K -R "select[mem>10] rusage[mem=10] span[hosts=1]" -n 8 "novoalign -d $NOVOIDX -f $umi5 -o SAM -n 50 -r None -c 8 -k 2> $stats5 | samtools view -ShuF4 - | samtools sort -o - $sample.11bp.temp -m 8G > $umi5bam"

# wait

# samtools index $umi1bam
# samtools index $umi2bam
# samtools index $umi3bam
# samtools index $umi4bam
# samtools index $umi5bam

# wait

# bam2bw.py -5 -v $umi1bam $SIZES pillai_kabos_polya
# bam2bw.py -5 -v $umi2bam $SIZES pillai_kabos_polya
# bam2bw.py -5 -v $umi3bam $SIZES pillai_kabos_polya
# bam2bw.py -5 -v $umi4bam $SIZES pillai_kabos_polya
# bam2bw.py -5 -v $umi5bam $SIZES pillai_kabos_polya
