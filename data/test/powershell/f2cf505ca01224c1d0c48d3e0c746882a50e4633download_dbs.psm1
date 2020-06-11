Add-PSSnapin KTools.PowerShell.SFTP  # available http://kevinrr3.blogspot.com/2013/02/sftp-in-powershell

function DownloadSftpFiles($sftpHost, $userName, $userPassword, $remoteDir, $localDbFileFolderPath) {

	#Open the SFTP connection
	$sftp = Open-SFTPServer -serverAddress $sftpHost -userName $userName -userPassword $userPassword

	#Show directory`s from remote root folder
	#$sftp.GetDirList("/")

	#Show file`s from remote root folder
	$files = $sftp.GetFileList($remoteDir)

	foreach($file in $files) {
		$rfp = $remoteDir + '/' + $file
		$lfp = $localDbFileFolderPath + '\' + $file
		Write-Host "$rfp -> $lfp"
		$sftp.Get($rfp, $lfp)
	}

	#$sftp.Get($fl, $localDbFileFolderPath)
	Write-Host "Done"

	#Close the SFTP connection
	$sftp.Close()
}