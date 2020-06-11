#!/bin/sh

# run tophat on simulated dataset

transcriptomeIndex=../Homo_sapiens/UCSC/hg19/Annotation/Transcriptome/known
bowtieIndex=../Homo_sapiens/UCSC/hg19/Sequence/Bowtie2Index/genome
dataDir=reads/large_variance
SLIST=`seq -f %02.0f 1 14`

for sample in $SLIST
do
    outdir=alignments/large_variance/sample${sample}
    cat > tophat_large_${sample}.sh <<EOF
    #!/bin/sh
    set -e
    module load tophat
    mkdir -p $outdir
    tophat -o $outdir -p 1 --transcriptome-index $transcriptomeIndex $bowtieIndex $dataDir/sample_${sample}_1.fasta $dataDir/sample_${sample}_2.fasta
    mv $outdir/accepted_hits.bam $FOLDERNAME/alignments/large_variance/sample${sample}_accepted_hits.bam 
EOF
    qsub -cwd -l mf=5G,h_vmem=5G tophat_large_${sample}.sh
done

