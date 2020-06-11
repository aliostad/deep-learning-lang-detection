#!/bin/bash

#g++ -c -pipe -g -Wall -W -fPIE -DQT_QML_DEBUG -DQT_DECLARATIVE_DEBUG -I../../../../../Qt/5.2.1/gcc_64/mkspecs/linux-g++ -I../background_separation_v2 -I. -o blobtrack_sample.o ../background_separation_v2/blobtrack_sample.cpp

g++ -c -pipe -g -Wall -W -fPIE -I../background_separation_v2 -I. -o blobtrack_sample.o ../background_separation_v2 -I. -o blobtrack_sample.o ../background_separation_v2/blobtrack_sample.cpp

#g++ -Wl,-rpath,/home/user/Qt/5.2.1/gcc_64 -o blobtrack_sample blobtrack_sample.o   -L/usr/local/lib -lopencv_highgui -lopencv_video -lopencv_imgproc -lopencv_core -lopencv_objdetect -lopencv_legacy 

#g++ -Wl,-rpath,/home/user/Qt/5.2.1/gcc_64 -o blobtrack_sample blobtrack_sample.o   -L/usr/local/lib -lopencv_highgui -lopencv_video -lopencv_imgproc -lopencv_core -lopencv_objdetect -lopencv_legacy

g++ -o blobtrack_sample blobtrack_sample.o   -L/usr/local/lib -lopencv_highgui -lopencv_video -lopencv_imgproc -lopencv_core -lopencv_objdetect -lopencv_legacy
