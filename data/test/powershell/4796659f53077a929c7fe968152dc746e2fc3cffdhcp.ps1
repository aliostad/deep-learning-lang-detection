Function prestart()
{
}

function run() 
{
	$isDHCP = $false
	if ($isServer -eq $true -and $isDeprecatedOS -eq $true) {    # Check for Win2003
		$isDHCP = $true
	}
	if (Get-Command "Get-WindowsFeature" -ErrorAction SilentlyContinue) {  # Check for >Win2003
		Get-WindowsFeature DHCP | Where-Object { $_.Installed -eq $true } | measure |% { if ($_.Count -eq 1) { $isDHCP = $true } }
	}	

	if ($isDHCP -eq $true) {
		Send-Line "<<<win_dhcp_pools>>>"
		$ret = Invoke-Expression "netsh dhcp server show mibinfo | find /V `": dhcp.`" | find /v `"Server may not function properly.`" | find /v `"Unable to determine the DHCP Server version for the Server`" | find /V `"DHCP-Serverversion wurde`" | find /V `"nicht richtig funktionieren.`" | find /V `": dhcp server show mibinfo.`""
		Send-Line $ret
	}

}

Function terminate()
{
}