<#
 	.SYNOPSIS
	This script parses NMAP ping sweeps into /24 network blocks and removes duplicate values.
	This script requires PoshSec-Mod installed, available at: https://github.com/darkoperator/Posh-SecMod

	Function: Get-ICMPSubnets
	Author: Matt Kelly, @breakersall
	Required Dependencies: PSv3,PoshSec-Mod by @DarkOperator

	.PARAMETER XMLPath

	Optionally specify the path containing the xml files, example: C:\Temp.

    .PARAMETER SavePath

	Optionally specify a file to save the documents to, example: C:\Temp\subnets.txt
		
#>
function get-ICMPSubnets
{
	[CmdletBinding()]
	Param(
			[Parameter(Mandatory=$false,
			HelpMessage='Provide a directory for, example: C:\Temp')]
			[ValidateScript({Test-Path $_})]
			[string]$XMLPath = (Get-Location),
			
			[Parameter(Mandatory=$false,
			HelpMessage='Provide a Computer to test for, attempts to ping to validate connection')]
			[string]$SavePath
		)
	$Networks = @()
	$Subnets = @()
	$Files = Get-ChildItem $XMLPath\*.xml
	foreach ($File in $Files){ $Networks += Import-NMapXML -NMapXML $File -InfoType hosts | Select-Object -ExpandProperty IPv4Address}
	foreach ($Network in $Networks)
	{
		$Subnets += [string]([ipaddress] "$Network").GetAddressBytes()[0] + "." + [string]([ipaddress] "$Network").GetAddressBytes()[1] + "." + [string]([ipaddress] "$Network").GetAddressBytes()[2] + ".0/24"
	}
	if ($SavePath)
	{
		$Subnets | Get-Unique | Out-File -File $SavePath
	}
	else
	{
		$Subnets | Get-Unique 
	}
}