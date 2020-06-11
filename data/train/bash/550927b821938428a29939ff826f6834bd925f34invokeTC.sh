#!/bin/bash --

print_help(){
	msg=" Argument	 	Value  (default)		Purpose
--url 			url (http://localhost:9085/tc)	path to mule invoke auto qc flow
--inputFile 		windows path (f:\\tcinput\\test.mxf)		input file
--outputFolder 		windows path (f:\\tcoutput) 		output folder"

	echo "$msg"

}


#set default values
muleurl=http://localhost:9085/tc
inputFile='f:\tcinput\test.mxf'
outputFolder='f:\tcoutput\'
packageID=testPackageID


#iterate through command line arguments
while [ $# -gt 0 ]
do
    case "$1" in
    (--url) muleurl="$2"; shift;;
    (--inputFile) inputFile="$2"; shift;;
    (--outputFolder) outputFolder="$2"; shift;;
    (--help)	print_help ; exit 0;;(-h)	print_help ; exit 0;;
    (-*) echo "$0: error - unrecognized option $1" 1>&2; exit 1;;
    (*)  break;;
    esac
    shift
done

#make http call

payload="<?xml version=\"1.0\"?>
<invokeIntalioTCFlow>
<inputFile>${inputFile}</inputFile>
<outputFolder>${outputFolder}</outputFolder>
<packageID>${packageID}</packageID>
</invokeIntalioTCFlow>"

echo "$payload" | curl -v -X POST -d @- -H "Content-Type: application/xml" "${muleurl}"
