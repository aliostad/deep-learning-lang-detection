function Show-LocalUsers {
	param(
		[Parameter(Mandatory=$true)]
		[string]$computer
	)

	$adsi = [ADSI]("WinNT://$computer,computer")
	$adsi.name
	
	$users = $adsi.psbase.children | Where {$_.psbase.schemaclassname -eq "User"} | Select Name
	foreach ($user in $users) {
		$user.name
	}
	<#
		.SYNOPSIS
			Shows local users
		.DESCRIPTION
			Shows local users on specified computer.
		.PARAMETER  computer
			Name of the computer
		.EXAMPLE
			PS C:\> Show-LocalUsers -Computer $env:computername
		.INPUTS
			System.String
		.OUTPUTS
			System.String
		.NOTES
			Written for Matt Johnson's GrrCON 2012 talk PowerShell - Be A Cool Blue Kid.
		.LINK
			www.mwjcomputing.com/resources/grrcon-2012/
		.LINK
			github.com/mwjcomputing/
	#>
	
}