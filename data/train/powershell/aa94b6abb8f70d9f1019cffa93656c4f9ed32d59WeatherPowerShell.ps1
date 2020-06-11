set-executionpolicy remotesigned
#Set The Path For Tools
$msbuild = "C:\Windows\Microsoft.NET\Framework\v4.0.30319\msbuild.exe"
$msdeploy="C:\Program Files\IIS\Microsoft Web Deploy\msdeploy.exe"
$FxCopDir="C:\Program Files\Microsoft FxCop 1.36"


# MS DEPLOY SETTINGS  
$baseDir = "D:\Weather\Weather.Api\"
$outputFolder = $baseDir + "Output"
$options = "/noconsolelogger /p:Configuration=Release"
$releaseFolder = $baseDir + "\bin\Release"
# if the output folder exists, delete it
if ([System.IO.Directory]::Exists($outputFolder))
{
 [System.IO.Directory]::Delete($outputFolder, 1)
}
# make sure our working directory is correct
cd $baseDir
# create the build command and invoke it 
$clean = $msbuild + " ""Weather.Api.sln"" " + $options + " /t:Clean"
$build = $msbuild + " ""Weather.Api.sln"" " + $options + " /t:Build"
Invoke-Expression $clean
Invoke-Expression $build
clear
#FxCop Steps
cd $FxCopDir 
$FxCopProjectFile=$baseDir+"WeatherFxCop.FxCop"
$FxCopCommand=.\FxCopCmd.exe /p:$FxCopProjectFile /console
$FxCopCommand

#MS Deploy Step
#change directory  to  project  file and build package for delploy to web server
cd D:\Weather\Weather.Api\Weather.Api
$package =$msbuild + " ""Weather.Api.csproj"" " + $options + " /t:Package"
Invoke-Expression $package



