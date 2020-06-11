## deploy service to remote box
try {
	Invoke-Command -ComputerName 'vstlnapp320' -ScriptBlock { net stop lacjam.servicebus}
	Write-Host "Done Stopping lacjam.servicebus"
}
catch [Exception]{
	Write-Host "Failed to stop lacjam.servicebus!"
	Write-Host $_.Exception.ToString()
}

$copy_from_path = "C:\software\Lacjam-Roadmap\*.*"
$copy_to_path = "\\vstlnapp320\Software\Roadmap\"
Copy-Item $copy_from_path $copy_to_path -Force -Recurse
Write-Host "Done Copying folder lacjam.servicebus"

Copy-Item '\\vstlnapp320\Software\lacjam.servicebus.dll.config' $copy_to_path -Force -Recurse
Write-Host "Done Copying RamStore config lacjam.servicebus"

try {
	Invoke-Command -ComputerName 'vstlnapp320' -ScriptBlock { net start lacjam.servicebus }
	Write-Host "Done Starting lacjam.servicebus"
}
catch [Exception]{
	Write-Host "Failed to start lacjam.servicebus"
	Write-Host $_.Exception.ToString()
}		