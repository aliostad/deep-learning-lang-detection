Function Copy-ItemUsingExplorer {

param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$True)]
        [string]$source,
        [Parameter(Mandatory=$true,ValueFromPipeline=$True)]
        [string]$destination,
        [Parameter(Mandatory=$true,ValueFromPipeline=$True)]
        [string]$username,
        [Parameter(Mandatory=$true,ValueFromPipeline=$True)]
        [string]$password,
        [int]$CopyFlags
        )

$net = New-Object -com WScript.Network
$drive = "Z:"
$path = $destination
if (test-path $drive) { $net.RemoveNetworkDrive($drive) }

$net.mapnetworkdrive($drive, $path, $true, $username, $password)
$CopyFlags = "0x" + [String]::Format("{0:x}", $CopyFlags)
$objShell = New-Object -ComObject 'Shell.Application'    
$objFolder = $objShell.NameSpace((gi $destination).FullName)
$objFolder.CopyHere((gi $source).FullName,$CopyFlags)

$net.RemoveNetworkDrive($drive)

}

$ScriptDir      = Split-Path $MyInvocation.MyCommand.Path -Parent
$source = $ScriptDir
Write-Output "source: " + $source;
$destination = "\\10.224.164.4\C$"
$username = "Emanifest\administrator"
$password = "Portallao123456"
Copy-ItemUsingExplorer -source $source -destination $destination -username $username -password $password -CopyFlags 16
Read-Host -Prompt "Complete. Press Enter to exit."
