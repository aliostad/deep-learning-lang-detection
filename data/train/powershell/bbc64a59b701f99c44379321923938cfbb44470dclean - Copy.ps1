CLS
# Load the SharePoint PowerShell Snapin, if not already loaded
.\sub\LoadSharePointSnapin.ps1

Write-Host "Loading deployment config" -ForeGroundColor Green
try
{
   
	$xml = [xml](Get-Content   ".\config.xml")
    
}
catch [Exception]
{
	Write-Host $("* Field does not contain valid XML: "  + $_.Exception.Message) -ForeGroundColor Red
}

if($xml.exe.solutions -ne $null)
{
	# Add Farm Solutions
	.\sub\ReTractRemoveFarmSolution.ps1 $xml.exe.solutions
}


# Restart Timer servies
.\sub\RestartTimerService.ps1

Write-Host "Deployment cleaned successfully!!!"

