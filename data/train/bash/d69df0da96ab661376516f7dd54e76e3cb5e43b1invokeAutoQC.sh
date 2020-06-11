#!/bin/bash --


check_bool_arg(){
	if [[ !  "$2" == "true" || "$2" == "false" ]] ; then
		echo "$1 must be either 'true' or 'false', aborting"
		exit 1
	fi
}

print_help(){
	msg=" Argument	 	Value  (default)		Purpose
--url 			url (http://localhost:9085/qc)	path to mule invoke auto qc flow
--assetID 		string (testAssetID)		asset id to use for autoqc
--isTX 			boolean (false) 		indicates if autoqc is part of send to tx"

	echo "$msg"

}


#set default values
muleurl=http://localhost:8088/qc
assetID=testAssetID
isTX=false


#iterate through command line arguments
while [ $# -gt 0 ]
do
    case "$1" in
    (--url) muleurl="$2"; shift;;
    (--assetID) assetID="$2"; shift;;
    (--isTX) check_bool_arg $1 $2 ; isTX="$2"; shift;;
    (--help)	print_help ; exit 0;;(-h)	print_help ; exit 0;;
    (-*) echo "$0: error - unrecognized option $1" 1>&2; exit 1;;
    (*)  break;;
    esac
    shift
done

#make http call

payload="<?xml version=\"1.0\"?>
<invokeIntalioQCFlow>
<assetId>${assetID}</assetId>
<forTXDelivery>${isTX}</forTXDelivery>
</invokeIntalioQCFlow>"

echo "$payload" | curl -v -X POST -d @- -H "Content-Type: application/xml" "${muleurl}"
