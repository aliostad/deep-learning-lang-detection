#!/bin/sh

REPO_LOCATION=/opt/grage-repository


if [ -d ${REPO_LOCATION} ] ; then 
	echo "Eliminando repo actual"
	rm -r /opt/grage-repository ;

fi


echo "Creando repo"
mkdir ${REPO_LOCATION}

echo "Creando directorio de includes"
mkdir ${REPO_LOCATION}/includes

echo "Creando directorio de librerias"
mkdir ${REPO_LOCATION}/lib

echo "Creando directorio de logs"
mkdir ${REPO_LOCATION}/logs

echo "Creando directorio de archivos de configuracion"
mkdir ${REPO_LOCATION}/conf

echo "Cambiando propietario del repositorio al usuario '$1'"
chown -R $1:$1 ${REPO_LOCATION}
