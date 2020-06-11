#! /bin/sh
if [ $# -eq 1 ]
then
	database=$1
else
	export PATH=$PATH:/usr/share/gforge/bin/:/usr/share/gforge/utils:/opt/gforge/utils
	database=`forge_get_config database_name`
fi
if [ "x$database" = "x" ]
then
	echo "Forge database name not found"
	exit 1
fi

echo "Cleaning up the database"
if type invoke-rc.d 2>/dev/null
then
	invoke-rc.d apache2 stop
	invoke-rc.d postgresql restart
else
	service httpd stop
	service postgresql restart
fi

su - postgres -c "dropdb -e $database"
echo "Executing: pg_restore -C -d template1 < /root/dump"
su - postgres -c "pg_restore -C -d template1" < /root/dump

if type invoke-rc.d 2>/dev/null
then
	invoke-rc.d apache2 start
else
	service httpd start
fi
