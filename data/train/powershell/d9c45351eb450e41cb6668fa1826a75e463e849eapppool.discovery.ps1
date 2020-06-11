# sh.rcapi\api\functions\IIS\apppool.discovery.ps1 - Powershell
#
# Return a list of Application Pools for Zabbix Low-level Discovery
#
# Author: Jan Bouma | https://github.com/acropia/
If ( -Not (Test-Path Variable:RcApi)) {
	Write-Host "This script is not to be called directly.";
	Exit;
}

$logToScreen = $False;
$logToFile = $False;

Function ModuleMain {
	Try {
		Import-Module WebAdministration;
		$pools = Get-ChildItem "IIS:\AppPools" | Select-Object "Name";

		$output = "{`n";
		$output += "`t ""data"":[`n";


		$first = $True;

		Foreach ($pool in $pools) {
			if ($first -eq $False) {
				$output += ",`n";
			}
			$output += " { `"{#APPPOOLNAME}`":`"" + $pool.Name + "`" }"
			$first = $False;
		}
		$output += "`n";
		$output += "`t ]`n";
		$output += "}";

		Return $output;
	}
	Catch [Exception] {
		LogError $_.Exception.Message;
	}
}
