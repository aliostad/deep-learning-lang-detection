#!/bin/bash

ARCHIVE=`date +"%y"`"_"`date +"%m"`"_"`date +"%d"`".tar"
REPOSITORY="./Data"
SAVE="./archive/"

#0 is Sunday

#sauvegarde hebdomadaire
if [ `date +"%w"` == "1" ]; then #test si on est lundi
   if [ `date +"%d"` -lt 8 ]; then #si on est le premier lundi du mois
      echo "suppression des archives du mois..."
      find $SAVE -name *.tar -newer save.bck.month -exec rm {} \;
      echo "Creation du fichier de memo du mois"
      touch save.bck.month
   else
      echo "suppression des archives de la semaine..."
      find $SAVE -name *.tar -newer save.bck.week -exec rm {} \;
   fi
   echo "Archivage de tout le repertoire..."
   tar -cf $SAVE$ARCHIVE $REPOSITORY
   echo "Creation du fichier de memo de la semaine..."
   touch save.bck.week
else
   #sauvegarde journaliere
   echo "Sauvegarde des fichiers modifies..."
   find $REPOSITORY -newer save.bck.day -exec tar -cf $SAVE$ARCHIVE {} \;
   echo "Creation du fichier de memo de la journee"
   touch save.bck.day
fi
