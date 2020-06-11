#!/bin/bash
##MYSQL config
DBHOST="127.0.0.1"
DBNAME="zabbix"
DBUSER="root"
DBPASS="Alsyon78*"

# Utilitaires
MYSQLIMPORT="`which mysqlimport`"
GUNZIP="`which gunzip`"
DATEBIN="`which date`"
MKDIRBIN="`which mkdir`"

# Path
MAINDIR="/etc/zabbix/script"
DUMPFILE="${MAINDIR}/zabbix_db_bck-`${DATEBIN} +%Y%m%d%H%M`"
DBZABBIX=$1

## Arret des services
echo "Arret du service apache2"
invoke-rc.d apache2 stop
echo "Arret du service Zabbix-server"
invoke-rc.d zabbix-server stop

# Restauration de la base Zabbix
${GUNZIP} < ${DBZABBIX} | mysql -h ${DBHOST} -u ${DBUSER} -p${DBPASS} ${DBNAME}
#${MYSQLIMPORT} -h ${DBHOST} -u ${DBUSER} -p${DBPASS} ${DBNAME} [backupfile.sql]

## Démarrage des services
echo "Démarrage du service Apache2"
invoke-rc.d apache2 start
echo "Démarrage du service Zabbix-server"
invoke-rc.d zabbix-server start
echo
echo "Restauration finie avec succès - ${DUMPFILE}"

