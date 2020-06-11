#!/bin/bash

# Author : Quadeare
# Twitter : @quadeare

# Date format
DATE=$(date +"%d-%b-%Y-%T")

# Login mysql sauvegarde
MYSQL_USER='BACKUPUSER_NAME'
MYSQL_PASS='BACKUPUSER_PASSWORD'

# Save folder
SAVE_FOLDER='/var/mysql_backup'

# Time to live Saves
SAVE_TTL=10

# List databases
LISTEBDD=$( echo 'show databases' | mysql -u$MYSQL_USER -p$MYSQL_PASS )

# Loop on each database and backup
for SQL in $LISTEBDD

do

  if [ $SQL != "performance_schema" ] && [ $SQL != "information_schema" ] && [ $SQL != "mysql" ] && [ $SQL != "Database" ]; then

    # If no save folder, we create it !
    mkdir -p $SAVE_FOLDER/$SQL

    # Dump SQL file and compress it
    mysqldump -u$MYSQL_USER -p$MYSQL_PASS $SQL | gzip > $SAVE_FOLDER/$SQL/$SQL"_mysql_"$DATE.sql.gz

    # Delete old saves
    find $SAVE_FOLDER/$SQL/* -mtime +$SAVE_TTL -exec rm -f {} \;

  fi

done
