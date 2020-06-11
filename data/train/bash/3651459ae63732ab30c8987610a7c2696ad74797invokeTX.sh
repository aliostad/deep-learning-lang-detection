#!/bin/bash --


print_help(){
	msg=" Argument	 	Value  (default)		Purpose
--url 			url (http://localhost:9085/qc)	path to mule invoke tx delivery flow
--packageID 		string (testpackageID)		package id to use for tx delivery"

	echo "$msg"

}


#set default values
muleurl=http://localhost:9085/tx
packageID=testpackageID


#iterate through command line arguments
while [ $# -gt 0 ]
do
    case "$1" in
    (--url) muleurl="$2"; shift;;
    (--packageID) packageID="$2"; shift;;
    (--help)	print_help ; exit 0;;(-h)	print_help ; exit 0;;
    (-*) echo "$0: error - unrecognized option $1" 1>&2; exit 1;;
    (*)  break;;
    esac
    shift
done

#make http call
payload="<?xml version=\"1.0\"?>
<invokeIntalioTXFlow>
<packageID>${packageID}</packageID>
</invokeIntalioTXFlow>"

echo "$payload" | curl -v -X POST -d @- -H "Content-Type: application/xml" "${muleurl}"
