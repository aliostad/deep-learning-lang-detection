#
# Edouard Kombo <edouard.kombo@gmail.com>
# 2015/03/08
# Powershell script
# Download multiples files through ftp with Powershell
#

$powershellDir  = "c:/PowerShellFtp"
$saveDirectory  = $powershellDir + "/save"
$saveDirectoryF = $powershellDir + "/save/*.JPG"
$printDirectory = $powershellDir + "/print"
$chilkatDllDir  = "c:\PowerShellFtp\Assembly\ChilkatDotNet45.dll"

[Reflection.Assembly]::LoadFile($chilkatDllDir)

$ftp = New-Object Chilkat.Ftp2

#  Any string unlocks the component for the 1st 30-days.
$success = $ftp.UnlockComponent("Anything for 30-day trial")
if ($success -ne $true) {
    $($ftp.LastErrorText)
    exit
}

$ftp.Hostname = "10.0.1.11"
$ftp.Port     = 26000
$ftp.Username = "snitch"
$ftp.Password = "headoo"

#  Connect and login to the FTP server.
$success = $ftp.Connect()
if ($success -ne $true) {
    $($ftp.LastErrorText)
    exit
}

#  Download all files with filenames matching "ftp_*.asp";
#  The files are downloaded into c:/temp
$numFilesDownloaded = $ftp.MGetFiles("*",$saveDirectory)
if ($numFilesDownloaded -lt 0) {
	$($ftp.LastErrorText)
	exit
}
#$ftp.Disconnect()
$([string]$numFilesDownloaded + " Files Downloaded!")
Start-Sleep -sec $interval
