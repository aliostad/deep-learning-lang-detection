#!/bin/bash 

TMP_PATH=`mktemp -d -t gstringer`
IFS='
'

SAMPLE_NUM=1;
SAMPLE_LIST="";


if [ "$(which ffmpeg)" == "" ]; then 
	echo "no ffmpeg installed :(";
	exit -1
fi


while read LINE; do
	QUOTED_LINE=`python -c "import urllib, sys; print urllib.quote(sys.stdin.read().replace('\n',''))" <<EOF
$LINE
EOF`
	if [ "$QUOTED_LINE" == "" ]; then
		continue
	fi
	SAMPLE_URL="https://translate.google.com/translate_tts?ie=UTF-8&&tl=pt&total=100&idx=1&textlen=50000&client=t&q=${QUOTED_LINE}"
	SAMPLE_PATH="${TMP_PATH}/${SAMPLE_NUM}.mp3"
	echo "Fetching \"${LINE}\""
	echo -e "\t=> \"${SAMPLE_PATH}\"";
	curl -A "Mozilla/5.0" --stderr /dev/null "${SAMPLE_URL}" >"${SAMPLE_PATH}" 
	SAMPLE_NUM=$(($SAMPLE_NUM+1))
	SAMPLE_LIST="${SAMPLE_LIST}
file '${SAMPLE_PATH}'"
done;

[ -f "output.mp3" ] && rm output.mp3
ffmpeg -f concat -i - -c copy output.mp3 <<EOF
${SAMPLE_LIST}
EOF


