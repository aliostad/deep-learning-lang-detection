#/bin/bash
TARGET_PATH='../../../../../data';
LOAD_HISTORY_FILENAME='load_history.txt';
FILE=$TARGET_PATH/$LOAD_HISTORY_FILENAME;
#LOAD=`uptime | awk -F'[a-z]:' '{ print $2}' | awk '{print $1}'`;
LOAD=`top -l 1 -n 1 | grep "CPU usage" | awk {'print $3'}`;
LOAD=${LOAD/\%};
if [ ! -f $FILE ]; then
  echo -e "[ \n \"$LOAD\" \n ]" > $FILE;
fi

while true;do
  LOAD=`top -l 1 -n 1 | grep "CPU usage" | awk {'print $3'}`;
  LOAD=${LOAD/\%};
  LINES_NUMBER=`wc -l $FILE | awk '{print $1}'`;
  if [ $LINES_NUMBER -gt 3600 ]; then 
    sed -i -e '3 d' $FILE; 
  fi
  sed -i '' -e '$ d' $FILE; 
  echo -e ",\"$LOAD\" \n ]"  >> $FILE;
  sleep 5;
done
