#!/bin/sh

# load sample objects for different formats

BASE=`dirname $0`

# audio (wav master, mp3 service)
$BASE/fs-post.sh bd5939745h 1.wav $BASE/../sample/files/audio.wav
$BASE/fs-post.sh bd5939745h 2.mp3 $BASE/../sample/files/audio.mp3
$BASE/ts-put.sh bd5939745h $BASE/../sample/object/formatSampleAudio.rdf.xml

# data (tarball)
$BASE/fs-post.sh bd46428055 1.tar.gz $BASE/../sample/files/data.tar.gz
$BASE/ts-put.sh bd46428055 $BASE/../sample/object/formatSampleData.rdf.xml

# image (tif master, jpeg derivatives)
$BASE/fs-post.sh bd3379993m 1.tif $BASE/../sample/files/image.tif
$BASE/ts-put.sh bd3379993m $BASE/../sample/object/formatSampleImage.rdf.xml
$BASE/fs-derivatives.sh bd3379993m 1.tif

# image (tif master, jpeg derivatives)
$BASE/fs-post.sh bd86037516 1.tif $BASE/../sample/files/image.tif
$BASE/ts-put.sh bd86037516 $BASE/../sample/object/formatSampleImage.rdf.xml
$BASE/fs-derivatives.sh bd86037516 1.tif

# text (pdf master, jpeg derivatives)
$BASE/fs-post.sh bd2083054q 1.pdf $BASE/../sample/files/document.pdf
$BASE/ts-put.sh bd2083054q $BASE/../sample/object/formatSampleText.rdf.xml
$BASE/fs-derivatives.sh bd2083054q 1.pdf

# text (html)
$BASE/fs-post-cmp.sh bb01010101 2 2.html $BASE/../sample/files/webpage.html

# video (mov master, mp4 and jpeg derivatives)
$BASE/fs-post.sh bd0786115s 1.mov $BASE/../sample/files/video.mov
$BASE/fs-post.sh bd0786115s 2.mp4 $BASE/../sample/files/video.mp4
$BASE/fs-post.sh bd0786115s 3.jpg $BASE/../sample/files/video-preview.jpg
$BASE/fs-post.sh bd0786115s 4.jpg $BASE/../sample/files/video-thumbnail.jpg
$BASE/fs-post.sh bd0786115s 5.jpg $BASE/../sample/files/video-icon.jpg
$BASE/ts-put.sh bd0786115s $BASE/../sample/object/formatSampleVideo.rdf.xml
