copy ..\SimpleEntityApi.Web\Scripts\SimpleEntityApi\SimpleEntityApi.js .\content\Scripts
copy ..\SimpleEntityApi.Web\Scripts\SimpleEntityApi\SimpleEntityApi.min.js .\content\Scripts
copy ..\SimpleEntityApi.Web\Scripts\SimpleEntityApi\SimpleEntityApi.angular.js .\content\Scripts
copy ..\SimpleEntityApi.Web\Scripts\SimpleEntityApi\SimpleEntityApi.angular.min.js .\content\Scripts
copy ..\SimpleEntityApi.Web\bin\SimpleEntityApi.Library.dll .\lib\net40

del *.nupkg 

./NuGet.exe pack ./SimpleEntityApi.nuspec
$packageFile = dir SimpleEntityApi.*.nupkg
./NuGet.exe push $($packageFile.FullName)


