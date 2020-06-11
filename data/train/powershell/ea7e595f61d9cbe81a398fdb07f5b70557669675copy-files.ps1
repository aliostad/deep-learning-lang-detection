$list = Get-Content $args[0]
$copy_file = $args[1]
$copy_to = $args[2]

$log = New-Object System.Collections.ArrayList

$log_file = "Copy-Files.ps1"

$count = 0
$error_count = 0

$add_log = $log.Add("Copy-Files.ps1 " + $args)
$add_log = $log.Add("")
$add_log = $log.Add("`tStarted: " + (Get-Date))
$add_log = $log.Add("`tBy: " + ($ENV:USERDOMAIN).ToUpper() + "\" + ($ENV:USERNAME).ToLower())
$add_log = $log.Add("")
$add_log = $log.Add("========================================")
$add_log = $log.Add("")


foreach ($server in $list) {
	$count += 1
	$destination = "\\" + $server + $copy_to -replace ":","$"
	$copy = Copy-Item -Path $copy_file -Destination $destination
	if ($error) {
		Write-Host "ERROR: " $copy_file " could not be copied to" $destination "`b:" $error.Exception.Message()
		$add_log = $log.Add((Get-Date) + ":  ERROR: " $copy_file " could not be copied to" $destination "`b:" $error.Exception.Message())
		$error.Clear()
	}
	else {
		Write-Host $copy_file " could copied to" $destination "successfully"
		$add_log = $log.Add((Get-Date) + ":  " + $copy_file " copied to" $destination "successfully")
	}
}

foreach ($line in $log) {
	if ($line -match "ERROR:"){
		$error_count += 1
	}
}


$add_log = $log.Add("")
$add_log = $log.Add("========================================")
$add_log = $log.Add("")
$add_log = $log.Add("`tCompleted: " + (Get-Date))
$add_log = $log.Add("")
$add_log = $log.Add("`tSuccessful Copies:" + ($count - $error_count)
$add_log = $log.Add("`tFailed Copies: " + $error_count)
$add_log = $log.Add("`tTotal Copies: " + $count)

$out = $log | Out-File $log_file -Append -Encoding ASCII