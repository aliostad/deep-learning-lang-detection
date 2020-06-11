#!/bin/sh -x

# Create : Jerson
# Date   : 2008-08-25
# Purpose:
#         For change device model type, default is NSA220.
#         1. modify model id for different model
#         2. modify product name and model number for different model
#         3. modify model name for different model
#         4. modify system default configuration for different model
# USage   :
#          make NSA220 model => ./makemodel NSA220
#          make NSA220 PLUS model => ./makemodel NSA220PLUS

MODELNAME_FILE_PATH=../basicfs.initrd/etc/modelname
SYSTEM_DEFAULT_XML_FILE_PATH=../basicfs/etc/__system_default.xml

model=`echo $1 | tr a-z A-Z`

# Default model is STG100
case $model in
	STG100)
		MODEL_NAME="STG100"
		HOST_NAME="stg100"
		WORKGROUP_NAME="WORKGROUP"
	;;

	STG211)
		MODEL_NAME="STG211"
		HOST_NAME="stg211"
		WORKGROUP_NAME="WORKGROUP"
	;;

	STG212)
		MODEL_NAME="NAS-SERVER"
		HOST_NAME="nas-server"
		WORKGROUP_NAME="WORKGROUP"
	;;

	*)
		MODEL_NAME="STG100"
		HOST_NAME="stg100"
		WORKGROUP_NAME=$HOST_NAME
	;;
esac


# change model name
if [ -e $MODELNAME_FILE_PATH ]; then
	echo "modify model name to $MODEL_NAME in modelname....."
	echo $MODEL_NAME > $MODELNAME_FILE_PATH
else
	echo "error, modelname not exist....."
	exit 1
fi

exit 0

