#/bin/sh

if [ "$#" -lt 1 ]; then
  echo "Usage: $0 [conf-dir] <process-name>" >&2
  echo "Default conf-dir is ./conf" 
  exit -1
elif [ "$#" -eq 2 ] && [ ! -d $1 ]; then
  echo "Usage: $0 [conf-dir] <process-name>" >&2
  echo "$1: not a valid directory path"
  echo "Default conf-dir is ./conf" 
  exit -1
fi

CONF_DIR="conf"
PROCESS=""
if [ "$#" -eq 1 ]; then
  PROCESS="$1"
elif [ "$#" -eq 2 ]; then
  CONF_DIR="$1"
  PROCESS="$2"
fi

JAVA=`which java`

if [ "$JAVA" == "" ]; then
  echo "Unable to find Java Runtime in PATH"
  exit -1
else
  $JAVA -cp dataloader-30.0.0-uber.jar -Dsalesforce.config.dir=$CONF_DIR com.salesforce.dataloader.process.ProcessRunner process.name=$PROCESS
fi

