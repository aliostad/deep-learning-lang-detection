#DIR=$3
#START=${1%%_*}
#END=${2%%_*}

DIR=$1 # copy to $DIR

for NO in "${@:2}" ;do
SAMPLE=`ls |grep ^$NO`
echo $SAMPLE

if [ -d "$SAMPLE/exome" ];then
WORK_DIR=$SAMPLE/exome
CVR=$SAMPLE/stat/cve/cve.allchr
else
WORK_DIR=$SAMPLE/genome
CVR=$SAMPLE/stat/cvr/cvr.allchr
fi

if [ -n "$SAMPLE" ];then

if [ -d $DIR/$SAMPLE ];then
mkdir $DIR/$SAMPLE/old
mv $DIR/$SAMPLE/$SAMPLE.* $DIR/$SAMPLE/old
else
mkdir $DIR/$SAMPLE/
fi

echo "cp $WORK_DIR/mpileup/ano/*.sorted.ExAC $DIR/$SAMPLE/"
#cp $WORK_DIR/mpileup/ano/*.sorted.hgmd2 $DIR/$SAMPLE
cp $WORK_DIR/mpileup/ano/*.sorted.ExAC $DIR/$SAMPLE

echo "make $DIR/$SAMPLE/$SAMPLE.cvr.csv"
cat $CVR|perl /hpgwork/yoshimura/calc_coverage.pl >> $DIR/$SAMPLE/$SAMPLE.cvr.csv

echo "make $DIR/$SAMPLE/$SAMPLE.map.csv"
echo "Sample,#Reads,#MappedReads,#MappedReads(Unique),MappingRate(%),MappingRate(Unique)(%),Coverage(x),Coverage(Unique)(x)" > $DIR/$SAMPLE/$SAMPLE.map.csv
cat $SAMPLE/stat/map/*|perl /hpgwork/yoshimura/calc_map_rate.pl >> $DIR/$SAMPLE/$SAMPLE.map.csv

echo "make $DIR/$SAMPLE/$SAMPLE.dup.csv"
echo "Sample,#Unique,#Duplicate,#Reads,DuplicationRate(%)" > $DIR/$SAMPLE/$SAMPLE.dup.csv
cat $SAMPLE/stat/dup/dup.stat|perl /hpgwork/yoshimura/calc_dup.pl >> $DIR/$SAMPLE/$SAMPLE.dup.csv

echo "make $DIR/$SAMPLE/$SAMPLE.snv.csv"
echo "Sample,TotalSNVs,RareSNVs,RareSNVs(NS/SS),Gene(SNVs),TotalIndels,RareIndels,RareIndels(Coding),Gene(Indels),Gene" > $DIR/$SAMPLE/$SAMPLE.snv.csv
perl -pwe "s/\t/\,/g" $SAMPLE/stat/snv/*.stats >> $DIR/$SAMPLE/$SAMPLE.snv.csv

wc -l $DIR/$SAMPLE/$SAMPLE.*

else
echo $NO is not found!!
fi

done

