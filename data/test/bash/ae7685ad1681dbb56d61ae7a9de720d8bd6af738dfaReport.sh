#!/bin/bash
set -o nounset

function usage(){
	cat <<EOF
Trims adconion DFA report of header and footer rows.
USAGE: $0
  1) report file to clean
  2) output file (default /tmp/abohr/dfa_report_yyyymmdd.txt)
OPTIONS:
  -l Load: loads the file to MySQL table
EOF
	exit 1
}

function load(){
	fileToLoad=$1
	mysqlLoadScript="/home/abohr/mysql/load_dfa_report.sh"
	if [ ! -f $mysqlLoadScript ];then
		echo "Can't find mysql load script: $mysqlLoadScript"
	fi
	echo "Loading file $fileToLoad to MySQL"
	sh $mysqlLoadScript $fileToLoad		

}
###############################
#### MAIN
###############################
LOAD=
while getopts "l" OPT
do
	case $OPT in
	l)
		LOAD=1
		;;
	?)
		usage
	esac
	shift $(( OPTIND - 1 ));
done


if [ $# -lt 1 ];then
	usage
fi

report=$1
if [ $# -ge 2 ];then
	output="${2}"
else
	output="/tmp/abohr/dfa_report$(date +%Y%M%d)"
fi
header_rows=10
trailing_rows=1

# test that $1 is a file
if [ ! -f "$report" ];then
	echo "$report is not a file."
	exit 1
fi

rows=$(cat $report|wc -l )
start_row=$(( $header_rows+1 ))
end_row=$(( $rows - $trailing_rows ))
echo "$report has $rows lines"
sed -n "${start_row},${end_row}p" $report > $output

if [ -n $LOAD ];then
	load $output
fi
