if(!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
$arguments = "& '" + $myinvocation.mycommand.definition + "'" + "-ExecutionPolicy Bypass"
Start-Process "$psHome\powershell.exe" -Verb runAs -ArgumentList $arguments
break
}
$dir = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
$PMB = Get-ItemProperty "HKLM:\SOFTWARE\Wow6432Node\Pando Networks\PMB" | Select-Object -ExpandProperty "Program Directory"
$LoL = Get-ItemProperty "HKLM:\SOFTWARE\Wow6432Node\Riot Games\RADS" | Select-Object -ExpandProperty "LocalRootFolder"
$CG = Get-ItemProperty "HKLM:\SYSTEM\ControlSet001\Control\Session Manager\Environment" | Select-Object -ExpandProperty "CG_BIN64_PATH"
Function StartLoL {
Set-Location $LoL
Set-Location ..
Start-Process .\lol.launcher.exe
Set-location $LoL
}
New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" -Name NewKey -Value "Default Value" -Force
New-ItemProperty  -Path  "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" -Name "C:\Windows\Explorer.exe" -PropertyType "String" -Value 'NoDTToDITMouseBatch'
Invoke-Expression "Rundll32 apphelp.dll,ShimFlushCache"
$sScriptVersion = "1.3"
$Host.UI.RawUI.WindowTitle = "LoLTweaker $sScriptVersion"
Start-Process $PMB\uninst.exe /s
Set-Location $dir
Invoke-Item Mouseaccel.vbs
Set-Location $dir
New-Item -Path C:\Downloads\Backup -ItemType Directory
Stop-Process -ProcessName LoLLauncher
Stop-Process -ProcessName LoLClient
Get-ChildItem -Recurse -Force  $LoL | Unblock-File
Set-Location $LoL\solutions\lol_game_client_sln\releases
$sln = gci | ? {$_.PSIsContainer} | sort CreationTime -desc | select -f 1 | Select-Object -ExpandProperty "Name"
Set-Location $LoL\solutions\lol_game_client_sln\releases\$sln\deploy
Copy-Item .\dbghelp.dll C:\Downloads\Backup\dbghelp.dll.bak
Copy-Item .\msvcp110.dll C:\Downloads\Backup\msvcp110.dll.bak
Copy-Item .\msvcr110.dll C:\Downloads\Backup\msvcr110.dll.bak
Copy-Item .\msvcp120.dll C:\Downloads\Backup\msvcp120.dll.bak
Copy-Item .\msvcr120.dll C:\Downloads\Backup\msvcr120.dll.bak
Copy-Item .\cg.dll C:\Downloads\Backup\cg.dll.bak
Copy-Item .\cgD3D9.dll C:\Downloads\Backup\cgD3D9.dll.bak
Copy-Item .\cgGL.dll C:\Downloads\Backup\cgGL.dll.bak
Copy-Item .\tbb.dll C:\Downloads\Backup\tbb.dll.bak
Set-Location $LoL\projects\lol_launcher\releases
$launch = gci | ? {$_.PSIsContainer} | sort CreationTime -desc | select -f 1 | Select-Object -ExpandProperty "Name"
Set-Location $LoL\projects\lol_air_client\releases
$air = gci | ? {$_.PSIsContainer} | sort CreationTime -desc | select -f 1 | Select-Object -ExpandProperty "Name"
Set-Location "$LoL\projects\lol_air_client\releases\$air\deploy\Adobe Air\versions\1.0"
Copy-Item "Adobe Air.dll" "C:\Downloads\Backup\Adobe Air.dll.bak"
Set-Location $LoL\projects\lol_air_client\releases\$air\deploy\adobe air\versions\1.0\Resources
Copy-Item .\NPSWF32.dll C:\Downloads\Backup\NPSWF32.dll.bak
Set-Location $LoL\projects\lol_game_client\releases
$game = gci | ? {$_.PSIsContainer} | sort CreationTime -desc | select -f 1 | Select-Object -ExpandProperty "Name"
Set-Location $dir
$message = "Patch or Restore Backups"
$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Patch"
$no = New-Object System.Management.Automation.Host.ChoiceDescription "&Restore"
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
$result = $host.ui.PromptForChoice($title, $message, $options, 0)
switch ($result)
{
0 {
Set-Location $dir
Copy-Item .\dbghelp.dll $LoL\solutions\lol_game_client_sln\releases\$sln\deploy
Copy-Item .\msvcp120.dll $LoL\solutions\lol_game_client_sln\releases\$sln\deploy
Copy-Item .\msvcr120.dll $LoL\solutions\lol_game_client_sln\releases\$sln\deploy
Copy-Item $CG\cg.dll $LoL\solutions\lol_game_client_sln\releases\$sln\deploy
Copy-Item $CG\cgD3D9.dll $LoL\solutions\lol_game_client_sln\releases\$sln\deploy
Copy-Item $CG\cgGL.dll $LoL\solutions\lol_game_client_sln\releases\$sln\deploy
Copy-Item .\dbghelp.dll $LoL\projects\lol_air_client\releases\$air\deploy
Copy-Item .\tbb.dll $LoL\solutions\lol_game_client_sln\releases\$sln\deploy
Copy-Item .\NPSWF32.dll "$LoL\projects\lol_air_client\releases\$air\deploy\Adobe AIR\Versions\1.0\Resources"
Copy-Item ".\Adobe Air.dll" "$LoL\projects\lol_air_client\releases\$air\deploy\Adobe AIR\Versions\1.0"
Copy-Item $CG\cg.dll $LoL\projects\lol_launcher\releases\$launch\deploy
Copy-Item $CG\cgD3D9.dll $LoL\projects\lol_launcher\releases\$launch\deploy
Copy-Item $CG\cgGL.dll $LoL\projects\lol_launcher\releases\$launch\deploy
Copy-Item .\msvcp120.dll $LoL\projects\lol_launcher\releases\$launch\deploy
Copy-Item .\msvcr120.dll $LoL\projects\lol_launcher\releases\$launch\deploy
Copy-Item .\dbghelp.dll $LoL\projects\lol_game_client\releases\$game\deploy
Copy-Item .\msvcp120.dll $LoL\projects\lol_game_client\releases\$game\deploy
Copy-Item .\msvcr120.dll $LoL\projects\lol_game_client\releases\$game\deploy
Copy-Item $CG\cg.dll $LoL\projects\lol_game_client\releases\$game\deploy
Copy-Item $CG\cgD3D9.dll $LoL\projects\lol_game_client\releases\$game\deploy
Copy-Item $CG\cgGL.dll $LoL\projects\lol_game_client\releases\$game\deploy
Copy-Item .\tbb.dll $LoL\projects\lol_game_client\releases\$game\deploy
Copy-Item .\msvcp110.dll $LoL\projects\lol_game_client\releases\$game\deploy
Copy-Item .\msvcr110.dll $LoL\projects\lol_game_client\releases\$game\deploy
$tbb = [System.Diagnostics.FileVersionInfo]::GetVersionInfo("$LoL\solutions\lol_game_client_sln\releases\$sln\deploy\tbb.dll") | select -f 1 | Select-Object -ExpandProperty "FileVersion"
if($tbb -eq "4, 2, 0, 0"){
StartLoL
Read-Host "Patch Complete"
exit}
ELSE {
Read-Host "Patch Failed"
exit}
}
1 {
Set-Location C:\Downloads\Backup
Copy-Item .\dbghelp.dll.bak $LoL\solutions\lol_game_client_sln\releases\$sln\deploy\dbghelp.dll
Copy-Item .\msvcp110.dll.bak $LoL\solutions\lol_game_client_sln\releases\$sln\deploy\msvcp110.dll
Copy-Item .\msvcr110.dll.bak $LoL\solutions\lol_game_client_sln\releases\$sln\deploy\msvcr110.dll
Copy-Item .\msvcp120.dll.bak $LoL\solutions\lol_game_client_sln\releases\$sln\deploy\msvcp120.dll
Copy-Item .\msvcr120.dll.bak $LoL\solutions\lol_game_client_sln\releases\$sln\deploy\msvcr120.dll
Copy-Item .\cg.dll.bak  $LoL\solutions\lol_game_client_sln\releases\$sln\deploy\cg.dll
Copy-Item .\cgD3D9.dll.bak $LoL\solutions\lol_game_client_sln\releases\$sln\deploy\cgD3D9.dll
Copy-Item .\cgGL.dll.bak $LoL\solutions\lol_game_client_sln\releases\$sln\deploy\cgGL.dll
Copy-Item .\NPSWF32.dll.bak "$LoL\projects\lol_air_client\releases\$air\deploy\Adobe AIR\Versions\1.0\Resources\NPSWF32.dll"
Copy-Item "Adobe Air.dll.bak" "$LoL\projects\lol_air_client\releases\$air\deploy\Adobe AIR\Versions\1.0\Adobe Air.dll"
Copy-Item .\cg.dll.bak $LoL\projects\lol_launcher\releases\$launch\deploy\cg.dll.bak\cg.dll
Copy-Item .\cgD3D9.dll.bak $LoL\projects\lol_launcher\releases\$launch\deploy\cgD3D9.dll
Copy-Item .\cgGL.dll.bak $LoL\projects\lol_launcher\releases\$launch\deploy\cgGL.dll
Copy-Item .\msvcp120.dll.bak $LoL\projects\lol_launcher\releases\$launch\deploy\msvcp120.dll
Copy-Item .\msvcr120.dll.bak $LoL\projects\lol_launcher\releases\$launch\deploy\msvcr120.dll
Copy-Item .\dbghelp.dll.bak $LoL\projects\lol_game_client\releases\$game\deploy\dbghelp.dll
Copy-Item .\msvcp120.dll.bak $LoL\projects\lol_game_client\releases\$game\deploy\msvcp120.dll
Copy-Item .\msvcr120.dll.bak $LoL\projects\lol_game_client\releases\$game\deploy\msvcr120.dll
Copy-Item .\msvcp110.dll.bak $LoL\projects\lol_game_client\releases\$game\deploy\msvcp110.dll
Copy-Item .\msvcr110.dll.bak $LoL\projects\lol_game_client\releases\$game\deploy\msvcr110.dll
Copy-Item .\cg.dll.bak $LoL\projects\lol_game_client\releases\$game\deploy\cg.dll
Copy-Item .\cgD3D9.dll.bak $LoL\projects\lol_game_client\releases\$game\deploy\cgD3D9.dll
Copy-Item .\cgGL.dll.bak $LoL\projects\lol_game_client\releases\$game\deploy\cgGL.dll
Copy-Item .\tbb.dll.bak $LoL\projects\lol_game_client\releases\$game\deploy\tbb.dll
StartLoL
Exit
}
}