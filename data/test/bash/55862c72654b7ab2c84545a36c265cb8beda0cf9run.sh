#!/bin/bash
#java -Dapplication.properties=file:./application.properties -jar target/differ-cmdline-0.0.1-SNAPSHOT.jar --save-raw-outputs image.jpf
#java -Dapplication.properties=file:./application.properties -jar target/differ-cmdline-0.0.1-SNAPSHOT.jar --save-raw-outputs --save-report --save-properties image.jp2
#java -Dapplication.properties=file:./application.properties -jar target/differ-cmdline-0.0.1-SNAPSHOT.jar --save-raw-outputs --save-report --save-properties image.jpg
#java -Dapplication.properties=file:./application.properties -jar target/differ-cmdline-0.0.1-SNAPSHOT.jar --save-raw-outputs --save-report --save-properties image.tif
#java -Dapplication.properties=file:./application.properties -jar target/differ-cmdline-0.0.1-SNAPSHOT.jar --save-raw-outputs --save-report --save-properties ../docs/examples/images_01/01.jpg
#java -Dapplication.properties=file:../differ-common/src/main/resources/application.properties -jar target/differ-cmdline-0.0.1-SNAPSHOT.jar --save-raw-outputs --save-report --save-properties ../docs/examples/images_01/14.jpf
#java -Dapplication.properties=file:../differ-common/src/main/resources/application.properties -jar target/differ-cmdline-0.0.1-SNAPSHOT.jar --save-raw-outputs --save-report --save-properties ../docs/examples/images_03/05.djvu
#java -javaagent:/home/klas/lib/jip/profile/profile.jar -Dapplication.properties=file:./application.properties -jar target/differ-cmdline-0.0.1-SNAPSHOT.jar --save-raw-outputs --save-report --save-properties ../docs/examples/images_01/14.jpf
java -Dapplication.properties=file:../differ-common/src/main/resources/application.properties -jar target/differ-cmdline-0.0.1-SNAPSHOT.jar --save-raw-outputs --save-report --save-properties ../docs/images/TIFF/1002186430_000015.tif
