# parameter
param(
[string]$p
)
# end parameter

# config
$pathToImports = "E:\beets\imports"
# end config

# functions
function Get-Imported-Folder{
    $LastFileCaptured = gci $pathToImports | select -last 1
	$LastFileCapturedFullPath = $pathToImports + "\" + $LastFileCaptured
	$firstLine = Get-Content $LastFileCapturedFullPath -totalcount 1
	$pathToFolder = $firstLine.SubString(0,$firstLine.LastIndexOf("\"))
	Remove-Item $LastFileCapturedFullPath
    return $pathToFolder
}

function Show-BalloonTip {            
[cmdletbinding()]            
param(            
 [parameter(Mandatory=$true)]            
 [string]$Title,            
 [ValidateSet("Info","Warning","Error")]             
 [string]$MessageType = "Info",            
 [parameter(Mandatory=$true)]            
 [string]$Message,            
 [string]$Duration=10000            
)            

[system.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms') | Out-Null            
$balloon = New-Object System.Windows.Forms.NotifyIcon            
$path = Get-Process -id $pid | Select-Object -ExpandProperty Path            
$icon = [System.Drawing.Icon]::ExtractAssociatedIcon($path)            
$balloon.Icon = $icon            
$balloon.BalloonTipIcon = $MessageType            
$balloon.BalloonTipText = $Message            
$balloon.BalloonTipTitle = $Title            
$balloon.Visible = $true            
$balloon.ShowBalloonTip($Duration)            
}
# end functions

#Write-Host $path

C:\Python27\Scripts\beet.exe import $p

$newPath = Get-Imported-Folder
$pathToCover = $newPath + "\cover.jpg"
Remove-Item $pathToCover

$itunes = New-Object -ComObject iTunes.Application
$tracks = $itunes.LibraryPlaylist
$add = $tracks.AddFile($newPath)

$ballonMessage = "'" + $newPath + "' importiert!"
Show-BalloonTip -Title “Import erfolgreich!” -MessageType Info -Message $ballonMessage -Duration 1000