[system.Reflection.Assembly]::LoadWithPartialName("Microsoft.Forms") | Out-Null
foreach ($i in 1..100000) {
$x = Get-Random -Minimum 10 -Maximum 800 
$y = Get-Random -Minimum 10 -Maximum 800  
[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($x,$y)
}