#! /bin/bash


getweb(){
shopt -s -o nounset

local HOST
local FILE
HOST=${1:?'要提供主机域名或IP才行'}
FILE=${2:?'要提供下载到网页路径才行'}
port=80



if [[ ! $FILE == /* ]];then
FILE=/$FILE
fi


exec 6<>/dev/tcp/$HOST/$port



echo -e "GET $FILE HTTP/1.0" >&6
echo -e "HOET: $HOST" >&6
echo -e "Accept: */*" >&6
echo -e "Connection: close\n" >&6


SaveFile=${FILE##*/}

if [ -z "$SaveFile" ];then
Date=$(date +'%Y%m%d%H%M')
SaveFile="index$Date.html"
fi


cat <&6 >./web/$SaveFile


exec 6<&-
exec 6>&-
echo $SaveFile
}

