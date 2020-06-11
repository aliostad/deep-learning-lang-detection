#! /bin/sh
if [ $# -eq 1 ]
then
	database=$1
else
	scriptdir=$(dirname $0)
	if [ -d "$scriptdir/../../src" ]
	then
		UTILS_PATH=$(cd $scriptdir/../../src ; pwd)
	else
		UTILS_PATH=$(cd $scriptdir/../.. ; pwd)
	fi
	export PATH=$PATH:$UTILS_PATH/utils:$UTILS_PATH/bin
	if type forge_get_config
	then
		database=`FUSIONFORGE_NO_PLUGINS=true forge_get_config database_name`
	else
		echo "$0: FATAL ERROR : COULD NOT FIND forge_get_config"
		exit 1 
	fi
fi
if [ "x$database" = "x" ]
then
	echo "Forge database name not found"
	exit 1
else
	echo "Forge database is $database"
fi

echo "Stopping apache"
if type invoke-rc.d 2>/dev/null
then
	invoke-rc.d apache2 stop
else
	service httpd stop
fi

is_db_up () {
    echo "select count(*) from users;" | su - postgres -c "psql $database" > /dev/null 2>&1
}

echo "Stopping the database"
if type invoke-rc.d 2>/dev/null
then
	invoke-rc.d postgresql stop
else
	service postgresql stop
fi

echo "Waiting for database to be down..."
i=0
while [ $i -lt 10 ] && is_db_up ; do
    echo "...not yet ($(date))..."
    i=$(( $i + 1 ))
    sleep 5
done
if ! is_db_up ; then
    echo "...OK"
else
    echo "... FAIL: database still up?"
fi

sleep 5

echo "Starting the database"
if type invoke-rc.d 2>/dev/null
then
	invoke-rc.d postgresql start
else
	service postgresql start
fi

echo "Waiting for database to be up..."
i=0
while [ $i -lt 10 ] && ! is_db_up ; do
    echo "...not yet ($(date))..."
    i=$(( $i + 1 ))
    sleep 5
done
if is_db_up ; then
    echo "...OK"
else
    echo "... FAIL: database still down?"
fi

echo "Dropping database $database"
su - postgres -c "dropdb -e $database"

if [ -f /root/dump ]
then
	echo "Restore database from dump file: psql -f- < /root/dump"
	su - postgres -c "psql -f-" < /root/dump > /var/log/pg_restore.log 2>/var/log/pg_restore.err
else
	# TODO: reinit the db from scratch and create the dump
	echo "Couldn't restore the database: No /root/dump found"
	exit 2
fi

echo "Starting apache"
if type invoke-rc.d 2>/dev/null
then
	invoke-rc.d apache2 start
else
	service httpd start
fi

echo "Flushing/restarting nscd"
rm -f /var/cache/nscd/* || true
if type invoke-rc.d 2>/dev/null
then
    invoke-rc.d unscd restart || invoke-rc.d nscd restart || true
else
    service unscd restart || service nscd restart || true
fi
