i=$1
chr1=$2
outpath=$3
path=$4 #/ebi/microarray/home/johan/DATA/CAGEKID/RNASEQ_MAPPED_ENS66
type=$5 #tumor / normal
chr2=$6
echo "i:"
echo $i
echo "chr1:"
echo $chr1

picard="/nfs/ma/home/shyama/installed_soft/picard-tools-1.72/"
gmap="/nfs/ma/home/shyama/installed_soft/gmap-2012-12-07/bin/"
sampath="/nfs/ma/home/shyama/installed_soft/samtools-0.1.18/samtools"
igvtools="/nfs/ma/home/shyama/installed_soft/IGVTools/./igvtools"
perl_code_path="/nfs/ma/home/shyama/code/SYBARIS/Perl/"
bam="accepted_hits.bam"
unmapped="unmapped.bam"

echo $i
sample=`echo $i | cut -d '/' -f 1`
echo $sample
if [ "$chr2" == "" ]
then 
    echo "empty"
    sample=`echo $i | cut -d '/' -f 1`
    echo $sample
    mkdir $outpath$sample
    $sampath view $path$i$bam $chr1 > $outpath$sample"/"$chr1".sam"
    $sampath view $path$i$unmapped | sed 's,/1,,g' | sed 's,/2,,g' >> $outpath$sample"/"$chr1".sam" 
    mkdir $bsubout$sample
    java -jar $picard"SamToFastq.jar" INPUT=$outpath$sample"/"$chr1".sam" FASTQ=$outpath$sample"/s_chr"$chr1"_1.fastq" SECOND_END_FASTQ=$outpath$sample"/s_chr"$chr1"_2.fastq" INCLUDE_NON_PF_READS=true VALIDATION_STRINGENCY=SILENT
    sh /nfs/ma/home/shyama/code/CAGEKID/Shell/pre_post_trinityRun.sh $sample null "s_chr"$chr1"_" null $type $chr1  # -J $sample"_trinity_"$chr1 -w "done("$sample"_samToFasta_"$chr1")"
    $gmap./gmap -t 5 -f samse -D /nfs/ma/home/shyama/DATA/CAGEKID/reference/gmapDB/ -d HomoSapiens66 $outpath$sample/whole$chr1/Trinity.fasta > $outpath$sample/whole$chr1/Trinity.sam #-w "done("$sample"_trinity_"$chr1")" 
    $igvtools sort $outpath$sample"/whole"$chr1"/Trinity.sam" $outpath$sample/whole$chr1/$sample"Trinity.sorted.sam"
    mkdir $outpath$sample/whole$chr1/TrinityIndex
    bowtie2-build $outpath$sample/whole$chr1/Trinity.fasta $outpath$sample/whole$chr1/TrinityIndex/transcript
    mkdir $outpath$sample/whole$chr1/TrinityOut
    cd $outpath$sample
    perl $perl_code_path"fastq-filter-fixed_shyama.pl" "s_chr"$chr1"_1.fastq" "s_chr"$chr1"_2.fastq"
    mv $outpath$sample"/good/s_chr"$chr1"_1.fastq" $outpath$sample"/good/s_chr"$chr1"_1.fastq.gz"
    mv $outpath$sample"/good/s_chr"$chr1"_2.fastq" $outpath$sample"/good/s_chr"$chr1"_2.fastq.gz"
    bowtie2 -x $outpath$sample/whole$chr1/TrinityIndex/transcript -1 $outpath$sample"/good/s_chr"$chr1"_1.fastq.gz" -2 $outpath$sample"/good/s_chr"$chr1"_2.fastq.gz" -S $outpath$sample/whole$chr1/TrinityOut/$sample"_transcript_map.sam"
    $igvtools sort $outpath$sample/whole$chr1/TrinityOut/$sample"_transcript_map.sam" $outpath$sample/whole$chr1/TrinityOut/$sample"_transcript_map_sorted.sam"
    samtools view -f4 -S $outpath$sample/whole$chr1/$sample"Trinity.sorted.sam" > $outpath$sample/whole$chr1/unmapped_trinity.sam
    #/nfs/ma/home/shyama/installed_soft/trinityrnaseq_r2012-06-08/util/SAM_to_fasta.pl $outpath$sample/whole$chr1/unmapped_trinity.sam > $outpath$sample/whole$chr1/unmapped_trinity.fasta
    #/nfs/ma/home/SYBARIS/WGS-AF293/Shyama/BLAST+/ncbi-blast-2.2.26+/bin/./blastn -db /nfs/ma/home/shyama/DATA/CAGEKID/BLAST/DB/human_genomic_transcript/all_contig -query $outpath$sample/whole$chr1/unmapped_trinity.fasta -out $outpath$sample/whole$chr1/unmapped_blast.xml -outfmt 5
else
    echo $chr2
    echo $i
    sample=`echo $i | cut -d '/' -f 1`
    echo "two chromosome"
    echo $sample
    
    #mkdir $outpath$sample
    #$sampath view $path$i$bam $chr1 > $outpath$sample"/"$chr1"_"$chr2".sam"
    #$sampath view $path$i$unmapped | sed 's,/1,,g' | sed 's,/2,,g' >> $outpath$sample"/"$chr1"_"$chr2".sam"
    #$sampath view $path$i$bam $chr2 >> $outpath$sample"/"$chr1"_"$chr2".sam"
    
    #mkdir $bsubout$sample
    #java -jar $picard"SamToFastq.jar" INPUT=$outpath$sample"/"$chr1"_"$chr2".sam" FASTQ=$outpath$sample"/s_chr"$chr1"_chr"$chr2"_1.fastq" SECOND_END_FASTQ=$outpath$sample"/s_chr"$chr1"_chr"$chr2"_2.fastq" INCLUDE_NON_PF_READS=true VALIDATION_STRINGENCY=SILENT
    #sh /nfs/ma/home/shyama/code/CAGEKID/Shell/pre_post_trinityRun.sh $sample null "s_chr"$chr1"_chr"$chr2"_" null $type $chr1"_"$chr2
    #$gmap./gmap -t 5 -f samse -D /nfs/ma/home/shyama/DATA/CAGEKID/reference/gmapDB/ -d HomoSapiens66 $outpath$sample/whole$chr1"_"$chr2"/Trinity.fasta" > $outpath$sample/whole$chr1"_"$chr2"/Trinity.sam" # -w "done("$sample"_"$chr1")"
    #$igvtools sort $outpath$sample"/whole"$chr1"_"$chr2"/Trinity.sam" $outpath$sample/whole$chr1"_"$chr2"/"$sample"Trinity.sorted.sam"
    #mkdir $outpath$sample/whole$chr1"_"$chr2/TrinityIndex
    #bowtie2-build $outpath$sample/whole$chr1"_"$chr2/Trinity.fasta $outpath$sample/whole$chr1"_"$chr2/TrinityIndex/transcript
    #mkdir $outpath$sample/whole$chr1"_"$chr2/TrinityOut
    #cd $outpath$sample
    #perl $perl_code_path"fastq-filter-fixed_shyama.pl" "s_chr"$chr1"_chr"$chr2"_1.fastq" "s_chr"$chr1"_chr"$chr2"_2.fastq"
    #mv $outpath$sample"/good/s_chr"$chr1"_chr"$chr2"_1.fastq" $outpath$sample"/good/s_chr"$chr1"_chr"$chr2"_1.fastq.gz"
    #mv $outpath$sample"/good/s_chr"$chr1"_chr"$chr2"_2.fastq" $outpath$sample"/good/s_chr"$chr1"_chr"$chr2"_2.fastq.gz"
    #bowtie2 -x $outpath$sample/whole$chr1"_"$chr2/TrinityIndex/transcript -1 $outpath$sample"/good/s_chr"$chr1"_chr"$chr2"_1.fastq.gz" $outpath$sample"/good/s_chr"$chr1"_chr"$chr2"_2.fastq.gz" -S $outpath$sample/whole$chr1"_"$chr2/TrinityOut/$sample"_transcript_map.sam"
    #$igvtools sort $outpath$sample/whole$chr1"_"$chr2/TrinityOut/$sample"_transcript_map.sam" $outpath$sample/whole$chr1"_"$chr2/TrinityOut/$sample"_transcript_map_sorted.sam"
    #samtools view -f4 -S $outpath$sample/whole$chr1"_"$chr2"/"$sample"Trinity.sorted.sam" > $outpath$sample/whole$chr1"_"$chr2/unmapped_trinity.sam
    #/nfs/ma/home/shyama/installed_soft/trinityrnaseq_r2012-06-08/util/SAM_to_fasta.pl $outpath$sample/whole$chr1"_"$chr2/unmapped_trinity.sam > $outpath$sample/whole$chr1"_"$chr2/unmapped_trinity.fasta
    #/nfs/ma/home/SYBARIS/WGS-AF293/Shyama/BLAST+/ncbi-blast-2.2.26+/bin/./blastn -db /nfs/ma/home/shyama/DATA/CAGEKID/BLAST/DB/human_genomic_transcript/all_contig -query $outpath$sample/whole$chr1"_"$chr2/unmapped_trinity.fasta -out $outpath$sample/whole$chr1"_"$chr2/unmapped_blast.xml -outfmt 5
fi




#bsub -o /nfs/ma/home/shyama/outputs/CAGEKID/B00E4HB_blast_transcripts.out -M 16000 -R "rusage[mem=16000]" "/nfs/ma/home/SYBARIS/WGS-AF293/Shyama/BLAST+/ncbi-blast-2.2.26+/bin/./blastn -db /nfs/ma/home/shyama/DATA/CAGEKID/reference/transcripts/transcripts.fasta -query /nfs/ma/home/shyama/DATA/CAGEKID/data/tumor/B00E4HB/whole3/Trinity.fasta -gapopen 6 -gapextend 2 -out /nfs/ma/home/shyama/DATA/CAGEKID/data/tumor/B00E4HB/whole3/Trinity_blast_transcript.xml -outfmt 5"