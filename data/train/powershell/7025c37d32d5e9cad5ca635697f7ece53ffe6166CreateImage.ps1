# The purpose of this script is to be deployed on a VM that is to be converted into an Image.
# It will create a desktop icon that when clicked streamlines the rest of the process for the user (transforms the VM into an image)

# TODO:
# 1. Run the required process on the Vm
# 2. Call the api to notify that the vm is ready for capturing
# 3. Does the VM need to closed first?


#param ( [string]$SourceExe, [string]$ArgumentsToSourceExe, [string]$DestinationPath )
#$WshShell = New-Object -comObject WScript.Shell
#$Shortcut = $WshShell.CreateShortcut($DestinationPath)
#$Shortcut.TargetPath = $SourceExe
#$Shortcut.Arguments = $ArgumentsToSourceExe
#$Shortcut.Save()

#from: http://stackoverflow.com/questions/9701840/how-to-create-a-shortcut-using-powershell-or-cmd

function createShortcut([string]$sourceExe, [string]$sourceIcon, [string]$argumentsToSourceExe, [string]$destinationFile)
{
    $WshShell = New-Object -comObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($destinationFile)
    $Shortcut.TargetPath = $sourceExe
    $Shortcut.Arguments = $argumentsToSourceExe
	$shortcut.IconLocation= $sourceIcon
    $Shortcut.Save()
}

$captureFileName = 'capture.ps1'
$apiCallback = $args[0] #callback for ready to capture

$apiCallbackProvisioned = $args[1] #callback for vm provisioned (when the extension finished installing)

$chocoPackages = $args[2] #@()

$stream = [System.IO.StreamWriter] "c:\tnlabs.log"
$stream.WriteLine($args[0])
$stream.WriteLine($args[1])
$stream.WriteLine($args[2])

$param = '-noexit '+ (Get-Location).Path +'\capture.ps1 '''+$apiCallback +''''
$icoPath = (Get-Location).Path +'\capture.ico'

#copy to all desktops
$list = Get-ChildItem c:\users\ | ?{ $_.PSIsContainer }
$list = $list | where { Test-Path (Join-Path -path $_.FullName -ChildPath Desktop) }
$list | foreach {
    $path = Join-Path -path $_.FullName -ChildPath Desktop\Capture.lnk

   createShortcut 'powershell' $icoPath $param $path
}
#and also to disk C:
createShortcut 'powershell' $icoPath $param 'c:\\Capture.lnk'

#install Chocolatey
iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))

$stream.WriteLine("installing choco packages")

$chocoPackages -split "," | foreach{ cinst $_ }

$stream.WriteLine("invoking api method on: $apiCallbackProvisioned")
#let the system know the VM is ready for user configuration, and it can send the email
Invoke-RestMethod "$apiCallbackProvisioned"

$stream.WriteLine("invoked request to: $apiCallbackProvisioned")
$stream.WriteLine($apiCallbackProvisioned)
$stream.close()