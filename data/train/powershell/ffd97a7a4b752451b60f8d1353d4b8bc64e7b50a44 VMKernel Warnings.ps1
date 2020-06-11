$Title = "VMKernel Warnings"
$Header =  "ESX/ESXi VMKernel Warnings"
$Comments = "The following VMKernel issues were found, it is suggested all unknown issues are explored on the VMware Knowledge Base. Use the below links to automatically search for the string"
$Display = "Table"
$Author = "Alan Renouf"
$Version = 1.0

# Start of Settings 
# End of Settings 

$SysGlobalization = New-Object System.Globalization.CultureInfo("en-US")
$VMKernelWarnings = @()
foreach ($VMHost in ($VMH)){
	$Warnings = (Get-Log –VMHost ($VMHost) -Key vmkernel -ErrorAction SilentlyContinue).Entries | where {$_ -match "warning"}
	if ($Warnings -ne $null) {
		$VMKernelWarning = @()
		$Warnings | % {
			$Details = "" | Select-Object VMHost, Time, Message, Length, KBSearch, Google
			$Details.VMHost = $VMHost.Name
			$Details.Time = ([regex]::split($_, "WARNING: "))[0]
			$Message = $Message -replace "'", " "
			$Details.Message = $Message
			$Details.Length = ($Details.Message).Length
			$Details.KBSearch = "<a href='http://kb.vmware.com/selfservice/microsites/search.do?searchString=$Message&sortByOverride=PUBLISHEDDATE&sortOrder=-1' target='_blank'>Click Here</a>"
			$Details.Google = "<a href='http://www.google.co.uk/search?q=$Message' target='_blank'>Click Here</a>"
			if ($Details.Length -gt 0)
			{						
				$VMKernelWarning += $Details
			}
		}
		$VMKernelWarnings += $VMKernelWarning | Sort-Object -Property Length -Unique |select VMHost, Message, Time, KBSearch, Google
		
	}
}

$VMKernelWarnings |sort time -Descending
