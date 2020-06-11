#Pings all VMs on the specified ESXi host, comparing against previous results if they exist
param
(
	[alias("v")]
	[string]$vmHost = $(read-host -prompt "Enter the ESXi hostname"),
	[alias("r")]
	[string]$results = "E:\temp\Ping-test.txt",
	[alias("o")]
	[switch]$overwrite,
	[alias("a")]
	[switch]$append
)
if ($overwrite -and $append){write-error "Cannot Append and Overwrite; specify up to one option."; exit 20}
$allVMs = get-vmhost $vmHost | get-vm | where {$_.PowerState -eq "PoweredOn"}
$outResults = @()
$saveData = $false
if (!($overwrite) -and (test-path $results)){$outResults = get-content $results}
if ($overwrite -or $append -or !(test-path $results)){$saveData = $true}
$newDownSystems = @()
foreach ($thisVM in $allVMs)
{
	if(!($thisVM.guest.hostname) -or !(Test-Connection $thisVM.guest.hostname -count 1 -quiet))
	{
		#If the results file doesn't exist or if it's set to save to the file, record the ping results.  Otherwise, compare against the results
		if ($saveData)
		{
			write-host "Ping failure: $($thisVM.name)"
			$outResults += "Ping failure: $($thisVM.name)"
		}
		else
		{
			if (!(select-string $results -pattern $thisVM.name))
			{
				write-host "$('!'*10) Ping failure: $($thisVM.name)" -foregroundcolor red
				$newDownSystems += $thisVM.Name
			}
			else
			{
				write-host "(expected) Ping failure: $($thisVM.name)"
			}
		}
	}
}
if ($outResults){$outResults | select -unique | sort | set-content $results}
if ($newDownSystems)
{
	write-host ""
	write-host "Unexpectedly Down Systems"
	write-host "$('='*25)"
	$newDownSystems
}