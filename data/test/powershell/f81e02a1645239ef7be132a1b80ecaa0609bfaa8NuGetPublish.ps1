Function CreateSubFolders($dir){
    $lib = $dir + '\lib\net45'
    New-Item -ItemType Directory -Force -Path  $lib
	Copy-Item RestApiSdkClassic\bin\Release\RestApiSdk.dll $lib\RestApiSdk.dll

    $lib = $dir + '\lib\portable-net40+sl5+wp80+win8+wpa81'
    New-Item -ItemType Directory -Force -Path  $lib
	Copy-Item RestApiSdkUniversal\bin\Release\RestApiSdk.dll $lib\RestApiSdk.dll

    #$lib = $dir + '\lib\portable-net45+dnxcore50'
    #New-Item -ItemType Directory -Force -Path  $lib
	#Copy-Item RestApiSdkWin8\bin\Release\RestApiSdk.dll $lib\RestApiSdk.dll

    $lib = $dir + '\tools'
    New-Item -ItemType Directory -Force -Path  $lib
	Copy-Item install.ps1 $lib\install.ps1
}

try{
    $scriptpath = $MyInvocation.MyCommand.Path
    $dir = Split-Path $scriptpath
    Push-Location $dir
    
    CreateSubFolders($dir + '\NuGet')

	Push-Location 'NuGet'

    #This file could change name with a NuGet update for the NuGet command line package!
    Copy-Item ..\packages\NuGet.CommandLine.4.1.0\tools\NuGet.exe NuGet.exe
    Copy-Item ..\RestApiSdk.nuspec RestApiSdk.nuspec

	& .\NuGet.exe pack RestApiSdk.nuspec
	& .\NuGet.exe push Janglin.RestApiSdk.2.0.5.nupkg ec102be3-f205-454b-a412-d87ff0c9008c -source https://www.nuget.org/api/v2/package
}
finally{
	Push-Location '..'
    Remove-Item -Recurse -Force NuGet
}
