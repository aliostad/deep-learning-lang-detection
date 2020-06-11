#!/bin/bash

# rm -rf AndroidSample/app/*
# cp -R ask-sample.bak/app/* AndroidSample/app

rm -rf ask-sample/build.gradle
cp -R ask-sample.bak/build.gradle ask-sample/build.gradle

rm -rf ask-sample/src/main/AndroidManifest.xml
cp -R ask-sample.bak/src/main/AndroidManifest.xml ask-sample/src/main/AndroidManifest.xml

rm -rf ask-sample/src/main/res/layout/*
cp -R ask-sample.bak/src/main/res/layout/* ask-sample/src/main/res/layout

rm -rf ask-sample/src/main/res/menu
rm -rf ask-sample/src/main/res/values-v21
rm -rf ask-sample/src/main/res/values-w820dp

rm -rf ask-sample/src/main/res/values/*
cp -R ask-sample.bak/src/main/res/values/* ask-sample/src/main/res/values

rm -rf ask-sample/src/main/java/com/androidstarterkit/sample/*
cp -R ask-sample.bak/src/main/java/com/androidstarterkit/sample/* ask-sample/src/main/java/com/androidstarterkit/sample

cp ask-sample.bak/projectFiles/build.gradle build.gradle

#rm -rf ask-sample/google-services.json

rm -rf output

echo 'Success to recover sample project'
