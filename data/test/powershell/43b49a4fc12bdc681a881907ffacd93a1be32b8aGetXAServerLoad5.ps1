. (Join-Path (Split-Path -parent $MyInvocation.MyCommand.Definition) XAFunctions.ps1)

$XA5Farm = New-Object -ComObject MetaFrameCOM.MetaFrameFarm
$XA5Server = New-Object -ComObject MetaFrameCOM.MetaFrameServer
$XA5Farm.Initialize(1)

# 6 is the enumeration value for MetaFrameWinSrvObject
$XA5Server.Initialize(6, $Env:COMPUTERNAME)

$FarmName = $XA5Farm.FarmName
$ScriptRunTime = (Get-Date).ToFileTime()


$output = '{0}="{1}" ' -f "ServerName", $XA5Server.ServerName
$output += '{0}="{1}" ' -f "Load", $XA5Server.WinServerObject.ServerLoad

$output += '{0}="{1}" ' -f "FarmName",$FarmName
$output += '{0}="{1}"' -f "ScriptRunTime",$ScriptRunTime

Write-Host ("{0:MM/dd/yyyy HH:mm:ss} GMT - {1}" -f ((Get-Date).ToUniversalTime()), $output)