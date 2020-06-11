#!bin/sh
# macs peak calling and sample normalization script

sample=$1
control=$2
sampleSize=$(cat $sample | wc -l)
controlSize=$(cat $control | wc -l)
#echo "my->[${a}]"
#echo $sampleSize
# ucsc tools output is piped using '/dev/fd/1'
if [ "$controlSize" -le "$sampleSize" ]; then
	perl ~/src/perl/rand.pl $controlSize $sample | ~/src/useFul/ucsc/utilities/bedClip stdin ~/src/useFul/ucsc/genomeIndex/mm9.chrom /dev/fd/1 | sortBed -i > $sample.normalized
	echo "Sample Normalized"
	echo "Now running Macs"
	macs14 -t $sample.normalized -c $control -f BAM -g mm -n "$sample"
else 
	perl ~/src/perl/rand.pl $sampleSize $control| ~/src/useFul/ucsc/utilities/bedClip stdin ~/src/useFul/ucsc/genomeIndex/mm9.chrom /dev/fd/1 | sortBed -i > $control.normalized
	echo "Control Normalized"
	echo "Now running Macs"
        macs14 -t $sample -c $control.normalized -f BAM -g mm -n "$sample"
fi
