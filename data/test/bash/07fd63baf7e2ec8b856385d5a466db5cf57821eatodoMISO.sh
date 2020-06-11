
genome=mm9 ###
typeAnno=acembly ###
MISOPATH=/lab/jaenisch_albert/Apps/yarden/MixtureIsoforms/
eventGff=/lab/jaenisch_albert/genomes/${genome}/annos/${typeAnno} ###
targetBamFileBaseName=accepted_hits.sorted.bam  ### use the sorted one?
readLen=36 ###
pairedEndFlag="--paired-end 200 15"  #mean sd
clusterFlag="--use-cluster --chunk-jobs 1000"

thisScriptDir=`pwd`

cd ..

rootDir=`pwd`

cd $MISOPATH 

tophatOutputDir=$rootDir/tophatOutput
MISOOutputDir=$rootDir/MISOOutput
MISOSummaryDir=$rootDir/MISOSummary

mkdir $MISOSummaryDir

:<<'COMMENT'
#event analysis
mkdir $MISOOutputDir

for sampleDir in $tophatOutputDir/*; do

sampleName=`basename $sampleDir`

if [ ! -e $sampleDir/${targetBamFileBaseName} ];  then
	continue
fi

mkdir $MISOOutputDir/$sampleName
pwd
command="python run_events_analysis.py --compute-genes-psi ${eventGff} $sampleDir/${targetBamFileBaseName} --output-dir $MISOOutputDir/$sampleName --read-len $readLen $pairedEndFlag $clusterFlag > $MISOOutputDir/$sampleName/run_events_analysis.stdout 2> $MISOOutputDir/$sampleName/run_events_analysis.stderr"

echo $command
echo $command | qsub

done

COMMENT

#:<<'COMMENT'

# summarize

for sampleDir in $tophatOutputDir/*; do

sampleName=`basename $sampleDir`
echo "trying to summarize sample $sampleName"



misoOutputDirPerSample=$MISOOutputDir/$sampleName
misoSummaryDirPerSample=$MISOSummaryDir/$sampleName
mkdir $misoSummaryDirPerSample

rm -f $misoOutputDirPerSample/summarize_samples.std*
rm -f $misoSummaryDirPerSample/summarize_samples.std*

for prevOut in $misoOutputDirPerSample/*.std*; do
	bn=`basename $prevOut`
	mv $prevOut $MISOOutputDir/$sampleName.$bn
done

rm -Rf $misoSummaryDirPerSample/summary
rm -Rf $misoOutputDirPerSample/summary

python run_miso.py --summarize-samples $misoOutputDirPerSample $misoSummaryDirPerSample > $misoSummaryDirPerSample/summarize_samples.stdout 2> $misoSummaryDirPerSample/summarize_samples.stderr

done

#COMMENT