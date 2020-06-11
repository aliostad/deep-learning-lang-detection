
if [ $# -lt 1 ]; then
	echo $0 QThreshold
	exit
fi

Qt=$1


source ~/.bashrc
source ./initvars.sh


source $configDir/bwa.config.sh
source $tophatshvar


cd ..

#Qt=${qThresholds[1]}
procDir=processed_Q$Qt
qinfix=q$Qt.SAM


cd $samseDirOutCoyote
#samples=( R2 R3 R4 R5 )
#procDir=processed_Q10
#qinfix=q10.SAM


saveIFS=$IFS
IFS=`echo -en ","`
declare -a samples=($Samples)
IFS=$saveIFS

rootdir=`pwd`

allsampleconfig=$rootdir/allsamples.config

echo $configDir
echo $procDir $qinfix
echo $allsampleconfig

echo ${samples[@]}
#exit


rm $allsampleconfig

nsamples=${#samples[@]}

for((sample_i=0;sample_i<$nsamples;sample_i++)) do
	sample=${samples[$sample_i]}
	logout=$rootdir/$sample
	totalReadsThisSample=0
	totalReadsMappedThisSample=0
	totalReadsUnmappedThisSample=0
	totalReadsMappedPassQThisSample=0

	#if [ ! -d $i ]; then
	#	echo $i is not directory, continue
	#fi
	echo "processing sample $sample"
	cd $sample
		cd $procDir
		for part_out in *.part.stdout; do
			source $part_out
			cat $part_out
			totalReadsThisSample=`expr $totalReadsThisSample + $totalReads`
			totalReadsMappedThisSample=`expr $totalReadsMappedThisSample + $totalReadsMapped`
			totalReadsUnmappedThisSample=`expr $totalReadsUnmappedThisSample + $totalReadsUnmapped`
			totalReadsMappedPassQThisSample=`expr $totalReadsMappedPassQThisSample + $totalReadsPassQ`
		done	
		cd ..
		
	cd ..
	
	echo "sample=$sample" > ${logout}.config
	echo "totalReads=$totalReadsThisSample" >> ${logout}.config
	echo "totalReadsMapped=$totalReadsMappedThisSample" >> ${logout}.config
	echo "totalReadsUnmapped=$totalReadsUnmappedThisSample" >> ${logout}.config
	echo "totalReadsPassQ=$totalReadsMappedPassQThisSample" >> ${logout}.config

	
	echo "samples[$sample_i]=\"$sample\"" >> $allsampleconfig
	echo "totalReadss[$sample_i]=$totalReadsThisSample" >> $allsampleconfig
	echo "totalReadsMappeds[$sample_i]=$totalReadsMappedThisSample" >> $allsampleconfig
	echo "totalReadsUnmappeds[$sample_i]=$totalReadsUnmappedThisSample" >> $allsampleconfig
	echo "totalReadsPassQs[$sample_i]=$totalReadsMappedPassQThisSample" >> $allsampleconfig

done

echo "numSamples=$nsamples" >> $allsampleconfig
