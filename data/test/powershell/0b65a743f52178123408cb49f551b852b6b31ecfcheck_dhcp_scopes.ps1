############################################################
# check_dhcp_scopes
#
# Usage:
#   check_dhcp_scopes.ps1 -Warning <VALUE> -Critical <VALUE>
#
# Author:  Elliot Anderson <elliot.a@gmail.com>
# License: MIT
############################################################

Param (
	[ValidateRange(0,100)][Int]
	$Warning = 85,
	
	[ValidateRange(0,100)][Int]
	$Critical = 95
)

$Message = ""

$IsWarning  = 0
$IsCritical = 0

$ActiveScopes = Get-DhcpServerv4Scope | Where { $_.State -eq 'Active' }

if ($ActiveScopes) {
	$ActiveScopes | Foreach {
		$Scope = $_
		$Stats = Get-DhcpServerv4ScopeStatistics $Scope.ScopeId
		
		$Used = [Int] $Stats.PercentageInUse
		$Free = [Int] $Stats.Free

		switch ($Used) {
			{$_ -ge $Critical} { $IsCritical = $IsCritical + 1
				$Message += "$($Scope.Name) is Critical ($Used% used, $Free IP's available)`n"
			}
			{$_ -ge $Warning} { $IsWarning = $IsWarning + 1
				$Message += "$($Scope.Name) is Warning ($Used% used, $Free IP's available)`n"
			}
		}
	}
}

if ($Message) {
	Write-Output $Message
}

if ($IsCritical -gt 0) { exit 2 }
if ($IsWarning  -gt 0) { exit 1 }

Write-Output ("{0} Scopes Ok" -f $ActiveScopes.Count)

exit 0