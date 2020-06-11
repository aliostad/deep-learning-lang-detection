# powershell script to produce a redovisnings-mapp


# setup - clean all old files 

cd C:\Users\Sara\Desktop\Skola\ipmobil\special-spoon\redovisning
ls -Directory | remove-item -Recurse



## collect files for uppgift 1
mkdir 1
Copy-Item ..\Uppgift1\app\build.gradle 1
Copy-Item ..\Uppgift1\app\src\main\AndroidManifest.xml 1
Copy-Item ..\Uppgift1\app\src\main\java\com\example\sara\uppg1\NameGenerator.java 1
Copy-Item ..\Uppgift1\app\src\main\res\layout\activity_name_generator.xml 1
copy-item ..\Uppgift1\app\src\main\res\drawable-hdpi\ic_add_white_48dp.png 1
Copy-Item ..\Uppgift1\app\src\main\res\values\strings.xml 1
Copy-Item ..\Uppgift1\app\app-release.apk 1
Copy-Item '..\Uppgift1\Uppgift 1.3.txt' 1


## collect files for uppgift 2
mkdir 2
Copy-Item ..\Uppgift2\app\build.gradle 2
Copy-Item ..\Uppgift2\app\src\main\AndroidManifest.xml 2
Copy-Item ..\Uppgift2\app\src\main\java\com\example\sara\uppgift2\WelcomeScreen.java 2
Copy-Item ..\Uppgift2\app\src\main\java\com\example\sara\uppgift2\DisplayNumber.java 2
Copy-Item ..\Uppgift2\app\src\main\res\menu\main.xml 2
Copy-Item ..\Uppgift2\app\src\main\res\values\strings.xml 2
Copy-Item ..\Uppgift2\app\src\main\res\values\styles.xml 2
Copy-Item ..\Uppgift2\app\src\main\res\layout\* 2\.

## collect files for uppgift 3.1 - 3.3
mkdir 3
Copy-Item ..\Uppgift3\app\build.gradle 3
Copy-Item ..\Uppgift3\app\src\main\AndroidManifest.xml 3
Copy-Item ..\Uppgift3\app\src\main\java\com\example\sara\uppgift3\MainActivity.java 3
Copy-Item ..\Uppgift3\app\src\main\res\layout\activity_main.xml 3
Copy-Item ..\Uppgift3\app\src\main\res\values\dimens.xml 3
Copy-Item ..\Uppgift3\app\src\main\res\values\strings.xml 3

## collect files for uppgift 4.1.1 - 4.1.3
mkdir 4.1
Copy-Item ..\Uppgift4\app\build.gradle 4.1
Copy-Item ..\Uppgift4\app\src\main\AndroidManifest.xml 4.1
Copy-Item ..\Uppgift4\app\src\main\java\com\example\sara\uppgift4\* 4.1\.
Copy-Item ..\Uppgift4\app\src\main\res\layout\* 4.1\.
Copy-Item ..\Uppgift4\app\src\main\res\values\dimens.xml 4.1
Copy-Item ..\Uppgift4\app\src\main\res\values\strings.xml 4.1

## collect files for uppgift 6.1
mkdir 6.1
Copy-Item ..\Uppgift6.1\app\build.gradle 6.1
Copy-Item ..\Uppgift6.1\app\src\main\AndroidManifest.xml 6.1
Copy-Item ..\Uppgift6.1\app\src\main\res\values\strings.xml 6.1
Copy-Item ..\Uppgift6.1\app\src\main\res\layout\*.xml 6.1
Copy-Item ..\Uppgift6.1\app\src\main\java\com\example\sara\uppgift61\*.java 6.1

## collect files for uppgift 6.2
mkdir 6.2
Copy-Item ..\Uppgift6.2\app\build.gradle 6.2
Copy-Item ..\Uppgift6.2\app\src\main\AndroidManifest.xml 6.2
Copy-Item ..\Uppgift6.2\app\src\main\res\values\strings.xml 6.2
Copy-Item ..\Uppgift6.2\app\src\main\res\layout\*.xml 6.2
Copy-Item ..\Uppgift6.2\app\src\main\java\com\example\sara\uppgift62\*.java 6.2

## collect files for uppgift 7.1.1
mkdir 7.1.1
Copy-Item ..\Uppgift7.1.1\app\build.gradle 7.1.1
Copy-Item ..\Uppgift7.1.1\app\src\main\AndroidManifest.xml 7.1.1
Copy-Item ..\Uppgift7.1.1\app\src\main\res\values\strings.xml 7.1.1
Copy-Item ..\Uppgift7.1.1\app\src\main\res\layout\*.xml 7.1.1
Copy-Item ..\Uppgift7.1.1\app\src\main\java\com\example\sara\uppgift711\*.java 7.1.1

## collect files for uppgift 7.2.1
mkdir 7.2.1
Copy-Item ..\Uppgift7.2.1\app\build.gradle 7.2.1
Copy-Item ..\Uppgift7.2.1\app\src\main\AndroidManifest.xml 7.2.1
Copy-Item ..\Uppgift7.2.1\app\src\main\java\com\example\sara\uppgift721\*.java 7.2.1
Copy-Item ..\Uppgift7.2.1\app\src\main\res\layout\*.xml 7.2.1
Copy-Item ..\Uppgift7.2.1\app\src\main\res\values\dimens.xml 7.2.1
Copy-Item ..\Uppgift7.2.1\app\src\main\res\values\other_values.xml 7.2.1
Copy-Item ..\Uppgift7.2.1\app\src\main\res\values\strings.xml 7.2.1
Copy-Item ..\Uppgift7.2.1\app\src\main\res\values\styles.xml 7.2.1

## collect files for uppgift 7.2.2
mkdir 7.2.2
Copy-Item ..\Uppgift7.2.2\app\src\main\AndroidManifest.xml 7.2.2
Copy-Item ..\Uppgift7.2.2\app\src\main\java\com\example\sara\uppgift722\MainActivity.java 7.2.2
Copy-Item ..\Uppgift7.2.2\app\src\main\res\drawable\* 7.2.2\.
Copy-Item ..\Uppgift7.2.2\app\src\main\res\layout\activity_main.xml 7.2.2
Copy-Item ..\Uppgift7.2.2\app\src\main\res\values\dimens.xml 7.2.2
Copy-Item ..\Uppgift7.2.2\app\src\main\res\values\strings.xml 7.2.2

## collect files for uppgift 7.3.1
mkdir 7.3.1
Copy-Item ..\Uppgift7.3.1\app\build.gradle 7.3.1
Copy-Item ..\Uppgift7.3.1\app\src\main\AndroidManifest.xml 7.3.1
Copy-Item ..\Uppgift7.3.1\app\src\main\java\com\example\sara\internetcheck\MainActivity.java 7.3.1
Copy-Item ..\Uppgift7.3.1\app\src\main\res\layout\activity_main.xml 7.3.1
Copy-Item ..\Uppgift7.3.1\app\src\main\res\values\strings.xml 7.3.1
Copy-Item ..\Uppgift7.3.1\app\src\main\res\values\colors.xml 7.3.1


## collect files for uppgift 9
mkdir 9
Copy-Item ..\DinnerAid\app\build.gradle 9
Copy-Item ..\DinnerAid\app\src\main\AndroidManifest.xml 9
Copy-Item ..\DinnerAid\app\src\main\java\com\example\sara\dinneraid\*.java 9
Copy-Item ..\DinnerAid\app\src\main\res\layout\*.xml 9
Copy-Item ..\DinnerAid\app\src\main\res\values\strings.xml 9
Copy-Item ..\DinnerAid\app\src\main\res\values\colors.xml 9
Copy-Item ..\DinnerAid\app\src\main\res\values\dimens.xml 9
Copy-Item ..\DinnerAid\app\src\main\res\values\styles.xml 9
Copy-Item ..\DinnerAid\app\src\main\res\drawable\*.xml 9