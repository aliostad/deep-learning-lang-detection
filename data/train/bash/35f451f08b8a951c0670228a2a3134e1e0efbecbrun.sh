BASEDIR=$(dirname $0)

CONFIG_FILE=$BASEDIR/../../config

if [ -f $CONFIG_FILE ]; then
        . $CONFIG_FILE
fi

CHUNK=$BASEDIR/tmp/chunks
[ ! -d $BASEDIR/tmp ] && mkdir $BASEDIR/tmp;

if [ $USECACHE = 'n' ]; then
	echo "[$(date +"%T %D")] Loading omim disease from db..."
	perl $BASEDIR/get_dis.pl $DB $HOST $USER $PSW $DEBUG > $BASEDIR/tmp/dis

	echo "[$(date +"%T %D")] Start chunking files..."
	echo "[$(date +"%T %D")] Create/Empty chunk folder..."
	( [ -d $CHUNK ] && rm -f $CHUNK/* ) || mkdir $BASEDIR/tmp/chunks;

	echo "[$(date +"%T %D")] Chunking file..."
	(cp $BASEDIR/tmp/dis $CHUNK/dis && cd $CHUNK && split -n l/$NCBO_CHUNK_NUMBER -a 3 -d ./dis chunk_ && rm -f ./dis)
	#ls $CHUNK

	##NCBO
	echo "[$(date +"%T %D")] Start NCBO mapping..."
	for line in $(find $CHUNK -iname 'chunk_*'); do 
		perl $BASEDIR/ncbo.pl $line * &
	done

	echo "[$(date +"%T %D")] Waiting for process to be finished..."
	wait
	echo "[$(date +"%T %D")] Finish!"
	echo "[$(date +"%T %D")] Joining result..."
	for line in $(find $CHUNK -iname 'chunk_*_parsed'); do 
		cat $line >> $CHUNK/all
	done
	cp $CHUNK/all $CHUNK/../NCBO_omim2do_raw
fi


echo "[$(date +"%T %D")] Parsing result..."

echo "[$(date +"%T %D")] Updating db..."
mysql -h $HOST -u $USER -p$PSW $DB <$BASEDIR/run.sql
mysqlimport -h $HOST -u $USER -p$PSW --delete -L $DB $BASEDIR/tmp/NCBO_omim2do_raw
mysql -h $HOST -u $USER -p$PSW $DB <$BASEDIR/add_des.sql

exit 0;


#######old script
BASEDIR=$(dirname $0)

CONFIG_FILE=$BASEDIR/../../config

if [ -f $CONFIG_FILE ]; then
        . $CONFIG_FILE
fi

if [ $USECACHE = 'n' ]; then
echo 'loading OMIM disease from db...'$(date +"%T")
echo 'loading OMIM disease from db...'$(date +"%T") >>$LOG
perl $BASEDIR/getomim.pl $DB $HOST $USER $PSW > $BASEDIR/tmp/dis

echo 'start chunking files...'$(date +"%T")
echo 'start chunking files...'$(date +"%T") >>$LOG
echo 'empty chunk folder...'$(date +"%T")
echo 'empty chunk folder...'$(date +"%T") >> $LOG
rm $BASEDIR/tmp/chunks/*

echo 'spliting file...'$(date +"%T")
echo 'spliting file...'$(date +"%T") >> $LOG
split -n l/$NCBO_CHUNK_NUMBER -a 3 -d $BASEDIR/tmp/dis dis_chunk_
mv `pwd`/dis_chunk_* $BASEDIR/tmp/chunks/
ls $BASEDIR/tmp/chunks/
ls $BASEDIR/tmp/chunks/ >>$LOG

##query NCBO 
echo 'start queries ncbo...'$(date +"%T")
echo 'start queries ncbo...'$(date +"%T") >>$LOG
for i in $BASEDIR/tmp/chunks/dis_chunk_*
do
    if test -f "$i" 
    then
       	perl $BASEDIR/2hdo.pl $DB $HOST $USER $PSW $i &
    fi
done

echo 'waiting for process to be finished...'$(date +"%T")
echo 'waiting for process to be finished...'$(date +"%T") >>$LOG
wait

echo 'finish!'$(date +"%T")
echo 'finish!'$(date +"%T") >> $LOG
echo 'joining result...'
echo 'joining result...' >>$LOG
ls $BASEDIR/tmp/chunks/dis_chunk_*_parsed
ls $BASEDIR/tmp/chunks/dis_chunk_*_parsed >>$LOG
for i in $BASEDIR/tmp/chunks/dis_chunk_*_parsed
do
    if test -f "$i" 
    then
       	#perl $BASEDIR/2hdo.pl $DB $HOST $USER $PSW $i
	cat $i >> $BASEDIR/tmp/chunks/all
    fi
done

echo 'done!'$(date +"%T")

cp $BASEDIR/tmp/chunks/all $BASEDIR/tmp/NCBO_omim2do_raw
fi

echo "inserting into db..."$(date +"%T")
echo "inserting into db..."$(date +"%T") >>$LOG
mysql -h $HOST -u $USER -p$PSW $DB <$BASEDIR/run.sql
mysqlimport -h $HOST -u $USER -p$PSW --delete -L $DB $BASEDIR/tmp/NCBO_omim2do_raw
mysql -h $HOST -u $USER -p$PSW $DB <$BASEDIR/add_des.sql
exit;




















if [ $USECACHE = 'n' ]; then
echo "mapping disease to HDO...(50min)"$(date +"%T")
perl $BASEDIR/2hdo.pl $DB $HOST $USER $PSW >$BASEDIR/tmp/NCBO_omim2do_raw
#perl $BASEDIR/2hdo.pl $DB $HOST $USER $PSW
fi

echo "inserting into db..."$(date +"%T")
mysql -h $HOST -u $USER -p$PSW $DB <$BASEDIR/run.sql
mysqlimport -h $HOST -u $USER -p$PSW --delete -L $DB $BASEDIR/tmp/NCBO_omim2do_raw
echo "updating hdo deiease name..."$(date +"%T")
perl $BASEDIR/map_hdo_des.pl $DB $HOST $USER $PSW

#echo "joining MetaMap result..."
#mysql -h $HOST -u $USER -p$PSW $DB <$BASEDIR/caculate_all.sql
