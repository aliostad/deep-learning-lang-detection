#!/bin/sh

# run tophat on simulated dataset

transcriptomeIndex=../Homo_sapiens/UCSC/hg19/Annotation/Transcriptome/known
bowtieIndex=../Homo_sapiens/UCSC/hg19/Sequence/Bowtie2Index/genome
dataDir=reads_bias
SLIST=`seq -f %02.0f 1 7`

for sample in $SLIST
do
    outdir=alignments_bias/sample${sample}
    cat > tophat_bias_${sample}.sh <<EOF
    #!/bin/sh
    set -e
    module load tophat
    module load samtools
    mkdir -p $outdir
    tophat -o $outdir -p 1 --transcriptome-index $transcriptomeIndex $bowtieIndex $dataDir/sample_${sample}_1.fasta $dataDir/sample_${sample}_2.fasta
    mv $outdir/accepted_hits.bam $FOLDERNAME/alignments_bias/sample${sample}_accepted_hits.bam 
    samtools index alignments/sample${sample}_accepted_hits.bam
EOF
    qsub -cwd -l mf=5G,h_vmem=5G tophat_bias_${sample}.sh
done

