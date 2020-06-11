function Get-ScriptDirectory
{
    $Invocation = (Get-Variable MyInvocation -Scope 1).Value
    Split-Path $Invocation.MyCommand.Path
}

$scriptDir = ((Get-ScriptDirectory) + "\")
$moduleName = 'sayedha-pshelpers'
$modulePath = (Join-Path -Path $scriptDir -ChildPath ("{0}.psm1" -f $moduleName))

if(Test-Path $modulePath){
    "Importing pshelpers module from [{0}]" -f $modulePath | Write-Verbose

    if((Get-Module $moduleName)){
        Remove-Module $moduleName
    }
    
    Import-Module $modulePath -PassThru -DisableNameChecking | Out-Null
}
else{
    'Unable to find pshelpers module at [{0}]' -f $modulePath | Write-Error
}


Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms

# put an image on the clipboard
#$imageToPutOnClip = [System.Drawing.Image]::FromFile('C:\temp\img.bmp')
#[System.Windows.Forms.Clipboard]::SetImage($imageToPutOnClip)

#Trim-Image -fromClipboard -trimTop 20 | Save-Image -filePath 'C:\temp\img-fromclip.bmp' | Dispose-Object
#Trim-Image -fromClipboard -trimTop 20 | Save-Image -toClipboard | Dispose-Object
#Trim-Image -fromClipboard -trimTop 20 | Save-Image -toClipboard | Dispose-Object
#Save-Image -filePath 'C:\temp\img-fromclip.bmp' -fromClipboard

#$imageToPutOnClip.Dispose()
<#
New-ImageFromTexTAsButton -text "Manage Profiles..." -fontSize 9 | Save-Image -toClipboard | Dispose-Object
"Image is on the clipboard" | Write-Host

"all done" | Write-Host
#>
New-TextImageWhitebackground 'text on white bk2'
New-TextImageAsLink 'link here'
New-TextImageGreyBackground 'grey bk'