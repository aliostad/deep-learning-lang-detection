$list = Get-Content list.txt
$batch = "updatedsn.bat"
$log = "update-dsn.log"

foreach ($server in $list) {
	Write-Output "(Get-Date -Date)`t$server.ToUpper()" | Out-File $log -Append
	$copy_to = "\\" + $server + "c$\temp\" + $batch
	$copy_file = Copy-Item $batch $copy_to
	if ($error) {
		Write-Output "(Get-Date -Date)`t`tERROR: file copy to $server failed: $error[0].Exception.Message()" | Out-File $log -Append
		Write-Host "`tERROR: file copy to $server failed: $error[0].Exception.Message()"
	}
	else {
		Write-Output "(Get-Date -Date)`t`tFile copy to $server completed succesfully" | Out-File $log -Append
		Write-Host "`tFile copy to $server completed succesfully"
		$psexec_cmd = psexec /acceptEula $server $copy_to
		if ($psexec_cmd -gt 1) {
			Write-Output "(Get-Date -Date)`t`tERROR: psexec.exe failed on $server" | Out-File $log -Append
			Write-Host "`tERROR: psexec.exe failed on $server"
		else {
			Write-Output "(Get-Date -Date)`t`tPsexec.exe completed succesfully on $server" | Out-File $log -Append
			Write-Host "`tPsexec.exe completed succesfully on $server"
		}
	$error.clear()
	}
}
$log
