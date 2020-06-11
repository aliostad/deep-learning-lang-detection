#!/bin/bash
# Documentation:
# -blastx.sh <contigs.fa>

set -e
set -u
sample=$1
#cores=(`nproc`)
cores=8
echo '################################'
echo '### Running BLAST on '$sample' ###'
echo '################################'

# create directory for all the new files
mkdir ./$sample.blast
cp $sample ./$sample.blast
cd ./$sample.blast

pyfasta split -n $cores $sample

#grab only raw file name
temp_sample=${sample##*/}
sample_no_file_ending=${temp_sample%%.*}

contigs=(`find ./$sample_no_file_ending.*.fa -type f`)

for file in ${contigs[@]}
do
    filename=${file##*/}
    time blastx -db viral_prot -query $file -evalue 0.26 -matrix 'BLOSUM62' -word_size 3 -gapopen 11 -gapextend 1 -max_target_seqs 3 -outfmt "6 qseqid qlen sseqid evalue bitscore sskingdoms stitle sblastnames salltitles scomnames sscblyinames" -out ./$filename-blast.tsv -num_threads 2 -seg "yes" &
done
wait
cat ./$sample_no_file_ending.*.fa-blast.tsv > ./$sample-blast.tsv
cp $sample-blast.tsv ../
