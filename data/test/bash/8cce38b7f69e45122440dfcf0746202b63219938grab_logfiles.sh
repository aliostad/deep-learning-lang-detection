#!/bin/bash

######################################
#####################################

#Variable
LOG_FOLDER=/var/log/
SAVE_DIR=$1/files
TAR_DIR=$2
green='\033[0;32m'
cd $LOG_FOLDER

echo -e "${green}Script wordt uitgevoerd..."
echo "Moment..."

#Maakt de map aan
mkdir $SAVE_DIR
chmod 777 -R $SAVE_DIR

#Log files in de /var/log
for x in *.log.*
	do cp $x $SAVE_DIR 2> error.txt
		done
for x in *.log*
	do cp $x $SAVE_DIR 2> error.txt
		done
for x in *log.*
	do cp $x $SAVE_DIR 2> error.txt
		done
for x in *_log
	do cp $x $SAVE_DIR 2> error.txt
		done

#Log files binnen de mappen van /log/var/~
IFS=!
ARRAY=(`find * -maxdepth 0 -type d -printf %f!`)
COUNT="0"
touch error.manifest

for i in ${ARRAY[*]}; do
    cd $i
    if [ "$?" = "0" ]; then
	   for x in *.log.*
		do cp $x $SAVE_DIR 2> error.txt
		done
		for x in *_log
		do cp $x $SAVE_DIR 2> error.txt
		done
	else
		echo "cd mislukt"
	fi
    let COUNT++;
    cd ..
done

echo "Verzameling compleet!"

tar -cf $TAR_DIR $SAVE_DIR 2> error.txt
rm -r $SAVE_DIR
echo -e "${green}Script gelukt"

exit
