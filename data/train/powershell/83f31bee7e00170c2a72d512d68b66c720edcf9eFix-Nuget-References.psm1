function Fix-Nuget-References
{
    [CmdletBinding()]
	param
	(
        [Parameter(Mandatory=$True, HelpMessage="Path to version file.")]
        $FilePath,
		[Parameter(Mandatory=$True, HelpMessage="Name of package which requires version fix.")]
        $PackageName,
		[Parameter(Mandatory=$True, HelpMessage="Version of package which is to be set.")]
        $PackageVersion
	)
	BEGIN { }
	END { }
	PROCESS
	{
		$datetime = Get-Date
        "$($dateTime.ToUniversalTime().ToString()) : $Version" >> $FilePath
	}
}

Export-ModuleMember Fix-Nuget-References