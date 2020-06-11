#!/bin/bash

#----------------------------
# file : recuperationProcess.sh
#
# TODO : ... Claudie
#----------------------------


# recuperation des conf des differents process
#########################################
# Backup des conf des differents process
#########################################

# Backup des conf des differents process
recuperationConnecteur() {
   echo "recuperation du connecteur : debut"

   # recuperation du fichier contenant les connecteurs
    BACKUP_PROCESS=$1

   # cd $PLTDIR/scripts/ : permet de ce placer au niveau du repertoir ou ce trouve le fichier contenant les connecteurs
   # more                : permet d'afficher a l'ecran les informations contenue dans le fichier executable processList
    BACKUP_PROCESS=`awk '{
   for(i=1;i<=NF;i++){
        while($i!="kernel" && $i!="data1base" && $i!="data2base"&& $i!="tempo" && $i!="data5base"){
        do (touch backup$i.txt | cat repaxigate/processList/$i.txt >> backup$i.txt)} } }' repaxigate/processList`

   echo "recuperation du connecteur : fin"
}
