[void][Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')
$url = 'http://data.freedomcore.ru/freedomhead/maps.zip'
$local = "maps.zip"
$object = New-Object Microsoft.VisualBasic.Devices.Network
$object.DownloadFile($url, $local, '', '', $true, 500, $true, 'DoNothing')

$shell_app=new-object -com shell.application
$filename = "maps.zip"
$zip_file = $shell_app.namespace((Get-Location).Path + "\$filename")
$destination = $shell_app.namespace((Get-Location).Path)
$destination.Copyhere($zip_file.items())