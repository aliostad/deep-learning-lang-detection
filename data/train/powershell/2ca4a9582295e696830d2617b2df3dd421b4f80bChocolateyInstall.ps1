## Template VirtualEngine.Build ChocolateyInstall.ps1 file for extracted EXE/MSI installations
$packageToolsPath = Split-Path -parent $MyInvocation.MyCommand.Definition;
Install-ChocolateyZipPackage -PackageName 'appvmanage' -Url 'http://www.tmurgent.com/appv/Images/Tools/AppV_Manage/V3/Setup_AppV_Manage_5.0.1.0.zip' -UnzipLocation "$packageToolsPath";
## Install Msi
$setupAppVManagePath = Join-Path -Path $packageToolsPath -ChildPath 'Setup_AppVManage.msi';
Install-ChocolateyInstallPackage -PackageName 'appvmanage' -FileType 'MSI' -SilentArgs '/qn /norestart' -File "$setupAppVManagePath" -ValidExitCodes @(0,3010);
