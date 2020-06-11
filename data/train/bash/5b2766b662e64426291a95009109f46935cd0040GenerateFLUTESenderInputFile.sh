#!/bin/bash

#This script lists all the video and audio segments (in seperate files) along with their sizes.
#It uses the resulting files to generate a file that contains such a format:
#FileName Bytes Delay Bytes Delay Bytes Delay Bytes Delay.
#The FLUTE server would use this file to determine how much wait before sending corresponding chunk

videoSegmentIdentifier=*BBB_720_4M_video*		#Used to ignore video segments when processing audio segments
AudioSegmentIdentifier=*BBB_64k*		#Used to ignore video segments when processing audio segments

videoSegDur=1000000
frameRate=24					#This is the number of frames in a second segment
audioSegDur=980104

videoMetaDataSize=0				#Meta data size in bytes
audioMetaDataSize=0

tmpVideo="listOfVideoSegments.txt"
tmpAudio="listOfAudioSegments.txt"

videoProofing="Proofing_Video.txt"
audioProofing="Proofing_Audio.txt"

videoOutputFile="Chunks_Video.txt"
audioOutputFile="Chunks_Audio.txt"

videoTOIFile="Chunks_Video_Inband_Init.txt"
audioTOIFile="Chunks_Audio_Inband_Init.txt"

ls -l --ignore=$AudioSegmentIdentifier --ignore=*xml --ignore=*mpd --ignore=*init* --ignore=*sh --ignore=*txt --ignore=*~ | awk '{if ($5 != "" && $9 != "") {print $9" "$5}}' | sort -V > $tmpVideo
#awk -v videoSegDur=$videoSegDur -v videoMetaDataSize=$videoMetaDataSize '{fileSize=videoMetaDataSize;fileDur=0;dataLeft=0;durLeft=videoSegDur;dataLeft=$2-videoMetaDataSize; printf("%s ",$1);while (durLeft > 0) {dur=int((rand()+2)*100000); if (dur > durLeft) dur = durLeft; durLeft -= dur; chunk=int(dur*$2/videoSegDur); if (chunk > dataLeft ||durLeft ==0) chunk = dataLeft;dataLeft -= chunk;fileSize += chunk;fileDur +=dur; printf("%d %d ",chunk,dur)};printf("%d %d\n",fileSize+videoMetaDataSize,fileDur)}' $tmpVideo > $videoOutputFile

#Choose a random chunk duration between 50 and 150 msec
#awk -v SegDur=$videoSegDur -v MetaDataSize=$videoMetaDataSize -v proofing=$videoProofing '{fileSize=MetaDataSize;fileDur=0;dataLeft=0;durLeft=SegDur;dataLeft=$2-MetaDataSize; printf("%s %d ",$1,MetaDataSize);while (durLeft > 0) {dur=int((rand()+1)*100000); dur2=int((rand()+1)*100000); if (dur > durLeft) {dur = durLeft;dur2=0} else if (dur2 > durLeft - dur) dur2=durLeft-dur; durLeft = durLeft - dur - dur2; chunk=int(dur*$2/SegDur);if (dur2 ==0) chunk2=0; else chunk2=int(dur2*$2/SegDur); if (chunk > dataLeft || dur2 ==0 ) {chunk = dataLeft;chunk2=0} else if (chunk2 > (dataLeft - chunk) || durLeft == 0) chunk2 = dataLeft - chunk;dataLeft = dataLeft - chunk - chunk2; if ((chunk2 == 0 || dataLeft == 0) && dur2 != 0) {combinedDur = dur + dur2 +durLeft;avgDur = int(combinedDur/2);dur = avgDur;dur2 = combinedDur - dur;durLeft-=durLeft;combinedData=chunk+chunk2;avgData=int(combinedData/2);chunk = avgData;chunk2 = combinedData - chunk};fileSize = fileSize + chunk + chunk2;fileDur = fileDur + dur + dur2; if (dur2==0) printf("%d %d ",chunk,dur); else printf("%d %d %d %d ",chunk,dur,chunk2,dur2)} printf("\n"); printf("%d %d\n",fileSize,fileDur) > proofing}' $tmpVideo > $videoOutputFile

#Choose a frame duration. We send each frame as it becomes ready
awk -v FrameRate=$frameRate -v SegDur=$videoSegDur -v MetaDataSize=$videoMetaDataSize -v proofing=$videoProofing '{initialFrame=4;fileSize=MetaDataSize;fileDur=0;dataLeft=0;durLeft=SegDur;dataLeft=$2-MetaDataSize; printf("%s %d ",$1,MetaDataSize);while (durLeft > 0) {dur=int(SegDur/FrameRate); dur2=int(SegDur/FrameRate); if (dur > durLeft) {dur = durLeft;dur2=0} else if (dur2 > durLeft - dur) dur2=durLeft-dur; durLeft = durLeft - dur - dur2; chunk=int(dur*$2/SegDur)*initialFrame;initialFrame =1;if (dur2 ==0) chunk2=0; else chunk2=int(dur2*$2/SegDur); if (chunk > dataLeft || dur2 ==0 ) {chunk = dataLeft;chunk2=0} else if (chunk2 > (dataLeft - chunk) || durLeft == 0) chunk2 = dataLeft - chunk;dataLeft = dataLeft - chunk - chunk2; if ((chunk2 == 0 || dataLeft == 0) && dur2 != 0) {combinedDur = dur + dur2 +durLeft;avgDur = int(combinedDur/2);dur = avgDur;dur2 = combinedDur - dur;durLeft-=durLeft;combinedData=chunk+chunk2;avgData=int(combinedData/2);chunk = avgData;chunk2 = combinedData - chunk};fileSize = fileSize + chunk + chunk2;fileDur = fileDur + dur + dur2; if (dur2==0) printf("%d %d ",chunk,dur); else printf("%d %d %d %d ",chunk,dur,chunk2,dur2)} printf("\n"); printf("%d %d\n",fileSize,fileDur) > proofing}' $tmpVideo > $videoOutputFile


ls -l --ignore=$videoSegmentIdentifier --ignore=*xml --ignore=*mpd --ignore=*init* --ignore=*sh --ignore=*txt --ignore=*~ | awk '{if ($5 != "" && $9 != "") {print $9" "$5}}' | sort -V > $tmpAudio
#awk -v audioSegDur=$audioSegDur -v audioMetaDataSize=$audioMetaDataSize '{fileSize=0;fileDur=0;dataLeft=0;durLeft=audioSegDur;dataLeft=$2-audioMetaDataSize; printf("%s ",$1);while (durLeft > 0) {dur=int((rand()+2)*100000); if (dur > durLeft) dur = durLeft; durLeft -= dur; chunk=int(dur*$2/audioSegDur); if (chunk > dataLeft ||durLeft ==0) chunk = dataLeft;dataLeft -= chunk;fileSize += chunk;fileDur +=dur; printf("%d %d ",chunk,dur)};printf("%d %d\n",fileSize+audioMetaDataSize,fileDur)}' $tmpAudio > $audioOutputFile

#Choose a random chunk duration between 100 and 200 msec
#awk -v SegDur=$audioSegDur -v MetaDataSize=$audioMetaDataSize -v proofing=$audioProofing '{fileSize=MetaDataSize;fileDur=0;dataLeft=0;durLeft=SegDur;dataLeft=$2-MetaDataSize; printf("%s %d ",$1,MetaDataSize);while (durLeft > 0) {dur=int((rand()+1)*100000); dur2=int((rand()+1)*100000); if (dur > durLeft) {dur = durLeft;dur2=0} else if (dur2 > durLeft - dur) dur2=durLeft-dur; durLeft = durLeft - dur - dur2; chunk=int(dur*$2/SegDur);if (dur2 ==0) chunk2=0; else chunk2=int(dur2*$2/SegDur); if (chunk > dataLeft || dur2 ==0 ) {chunk = dataLeft;chunk2=0} else if (chunk2 > (dataLeft - chunk) || durLeft == 0) chunk2 = dataLeft - chunk;dataLeft = dataLeft - chunk - chunk2; if ((chunk2 == 0 || dataLeft == 0) && dur2 != 0) {combinedDur = dur + dur2 +durLeft;avgDur = int(combinedDur/2);dur = avgDur;dur2 = combinedDur - dur;durLeft-=durLeft;combinedData=chunk+chunk2;avgData=int(combinedData/2);chunk = avgData;chunk2 = combinedData - chunk};fileSize = fileSize + chunk + chunk2;fileDur = fileDur + dur + dur2; if (dur2==0) printf("%d %d ",chunk,dur); else printf("%d %d %d %d ",chunk,dur,chunk2,dur2)} printf("\n"); printf("%d %d\n",fileSize,fileDur) > proofing }' $tmpAudio > $audioOutputFile

#Choose chunk duration of 25msec
awk -v SegDur=$audioSegDur -v MetaDataSize=$audioMetaDataSize -v proofing=$audioProofing '{fileSize=MetaDataSize;fileDur=0;dataLeft=0;durLeft=SegDur;dataLeft=$2-MetaDataSize; printf("%s %d ",$1,MetaDataSize);while (durLeft > 0) {dur=25000; dur2=25000; if (dur > durLeft) {dur = durLeft;dur2=0} else if (dur2 > durLeft - dur) dur2=durLeft-dur; durLeft = durLeft - dur - dur2; chunk=int(dur*$2/SegDur);if (dur2 ==0) chunk2=0; else chunk2=int(dur2*$2/SegDur); if (chunk > dataLeft || dur2 ==0 ) {chunk = dataLeft;chunk2=0} else if (chunk2 > (dataLeft - chunk) || durLeft == 0) chunk2 = dataLeft - chunk;dataLeft = dataLeft - chunk - chunk2; if ((chunk2 == 0 || dataLeft == 0) && dur2 != 0) {combinedDur = dur + dur2 +durLeft;avgDur = int(combinedDur/2);dur = avgDur;dur2 = combinedDur - dur;durLeft-=durLeft;combinedData=chunk+chunk2;avgData=int(combinedData/2);chunk = avgData;chunk2 = combinedData - chunk};fileSize = fileSize + chunk + chunk2;fileDur = fileDur + dur + dur2; if (dur2==0) printf("%d %d ",chunk,dur); else printf("%d %d %d %d ",chunk,dur,chunk2,dur2)} printf("\n"); printf("%d %d\n",fileSize,fileDur) > proofing }' $tmpAudio > $audioOutputFile

awk 'BEGIN{TOI=1}{$1=TOI;print $0;TOI+=2}' $videoOutputFile > $videoTOIFile

awk 'BEGIN{TOI=1}{$1=TOI;print $0;TOI+=3}' $audioOutputFile > $audioTOIFile

rm $tmpVideo $tmpAudio $videoProofing $audioProofing $videoOutputFile $audioOutputFile
