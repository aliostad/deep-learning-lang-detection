#Allor script execute on  system
set-executionpolicy remotesigned
#Set The Path For Tools
$msbuild = "C:\Windows\Microsoft.NET\Framework\v4.0.30319\msbuild.exe"
$msdeploy="C:\Program Files (x86)\IIS\Microsoft Web Deploy\msdeploy.exe"
$fxcop="C:\Program Files (x86)\Microsoft FxCop 1.36"
$nunit="C:\Program Files (x86)\NUnit 2.6.2\bin\"
$ndepends="C:\Program Files\NDepend"

# MS BUILD SETTINGS  
$baseDir = "C:\Program Files (x86)\Jenkins\jobs\Weather QA - Weather.Api\workspace\Weather.Api"
$binDir = "C:\Program Files (x86)\Jenkins\jobs\Weather QA - Weather.Api\workspace\Weather.Api\Weather.Api\bin"
$objDir="C:\Program Files (x86)\Jenkins\jobs\Weather QA - Weather.Api\workspace\Weather.Api\Weather.Api\obj"
$options = " /p:Configuration=Release"
# if the output folder exists, delete it
if (  ([System.IO.Directory]::Exists($binDir)) -or ([System.IO.Directory]::Exists($objDir)) )
{
 
 [System.IO.Directory]::Delete($binDir, 1)
 [System.IO.Directory]::Delete($objDir, 1)
}

cd $baseDir
$clean = $msbuild + " ""Weather.Api.sln"" " + $options + " /t:Clean"
$build = $msbuild + " ""Weather.Api.sln"" " + $options + " /t:Build"
Invoke-Expression $clean
Invoke-Expression $build


#FXCOP STEPS
cd $fxcop 
$fxcoproject=$baseDir+"WeatherFxCop.FxCop"
$fxcopcommand=.\FxCopCmd.exe /p:$fxcoproject /console
$fxcopcommand


#NDEPENDS STEPS
cd $ndepends
$ndependproject=$baseDir+"WeatherNdepends.ndproj"
$ndependscommand=.\NDepend.Console.exe $ndependproject
$ndependscommand


#NUNIT Step
cd $nunit
$nunitcommand=.\nunit-console.exe C:\Program Files (x86)\Jenkins\jobs\Weather QA - Weather.Api\workspace\Weather.Api\Weather.Api.Tests\bin\Release\Weather.Api.Tests.dll
$nunitcommand

#MS DEPLOY PACKAGE
cd C:\Program Files (x86)\Jenkins\jobs\Weather QA - Weather.Api\workspace\Weather.Api\Weather.Api
$package =$msbuild + " ""Weather.Api.csproj"" " + $options + " /t:Package"
Invoke-Expression $package

#PUBLISH TO UAT SERVER 
$publishparamaeter ="/P:DeployOnBuild=True /P:DeployTarget=MSDeployPublish /P:MsDeployServiceUrl=https://192.168.0.142:8172/MsDeploy.axd /P:AllowUntrustedCertificate=True /P:MSDeployPublishMethod=WMSvc /P:CreatePackageOnPublish=True /P:DeployIisAppPath="Default Web Site/weather" /P:UserName=Administrator /P:Password=K4hvdrq2d3 "
$publish= $msbuild + " ""Weather.Api.sln"" " + $options + " /t:Build"
Invoke-Expression $publish





