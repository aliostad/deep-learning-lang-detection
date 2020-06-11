xbuild Sample.sln /target:Clean
xbuild Sample/Sample.csproj /target:Build
xbuild SampleApp/SampleApp.csproj /target:SignAndroidPackage

~/Library/Developer/Xamarin/android-sdk-macosx/platform-tools/adb uninstall Sample.Sample 
~/Library/Developer/Xamarin/android-sdk-macosx/platform-tools/adb uninstall SampleApp.SampleApp

~/Library/Developer/Xamarin/android-sdk-macosx/platform-tools/adb install SampleApp/bin/Debug/SampleApp.SampleApp-Signed.apk

~/Library/Developer/Xamarin/android-sdk-macosx/platform-tools/adb shell am instrument -w SampleApp.SampleApp/sample.TestRunner

