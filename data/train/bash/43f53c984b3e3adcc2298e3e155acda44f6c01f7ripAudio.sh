#!/bin/bash

videoName=$1
audioFile=$2
ar=44100
ac=2
ab=19200

if [ $# -lt 2 ] ; then
echo "Invalid number of arguments"
elif [ $# -eq 3 ] ; then
ar=$3
elif [ $# -eq 4 ] ; then
ar=$3
ac=$4
elif [ $# -eq 5 ] ; then
ar=$3
ac=$4
ab=$5
fi

ffmpeg -i $videoName -vn -ar $ar -ac $ac -ab $ab -f wav $audioFile < /dev/null
#ffmpeg -i sourceVideos/sample.mov -vn -acodec pcm_s16le -ar 44100 -ac 2 sample.wav
#ffmpeg -r 29.97 -i "sample/%07d.jpg" -i sample.wav -acodec mp2 -vcodec mpeg4 -b 3000000 -r 29.97 sample.mp4
#ffmpeg -r 29.97 -i "sample/%07d.jpg" -i sample.wav -acodec libfaac -vcodec mpeg4 -b 3000000 -r 29.97 sample.mp4
#ffmpeg -r 29.97 -i "sample/%07d.jpg" -i sample.wav -acodec libfaac -vcodec libxvid -b 3000000 -r 29.97 sample.mp4
#ffmpeg -r 29.97 -i "sample/%07d.jpg" -i sample.wav -acodec libfaac -vcodec libx264 -b 3000000 -r 29.97 sample.mp4
#ffmpeg -r 29.97 -i "sample/%07d.jpg" -i sample.wav -acodec libmp3lame -b 3000000 -ar 44100 -f flv sample.flv
#sudo ./configure --prefix="/usr/local/ffmpeg" --enable-gpl --enable-pthreads --enable-libxvid --enable-libmp3lame --enable-libfaac --enable-libfaad --enable-libx264

