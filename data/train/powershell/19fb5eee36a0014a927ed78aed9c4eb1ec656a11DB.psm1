[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SMO") | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SmoExtended") | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.ConnectionInfo") | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SmoEnum") | Out-Null

<#
	.DESCRIPTION
		Attaches database on specified SQL server. Existing DB will be detached
#>
Function Add-Database ($server, $databaseName, $dataFileName, $logFileName)
{
    if ($server.databases[$databaseName] -ne $NULL) {
        $server.DetachDatabase($databaseName, $false)
    }

	$sc = new-object System.Collections.Specialized.StringCollection; 
	$sc.Add($dataFileName) | Out-Null; 
	$sc.Add($logFileName) | Out-Null;
	
	$server.AttachDatabase($databaseName, $sc); 
    Write-Output "Database $databaseName successfully attached."
}
 
Export-ModuleMember -function Add-Database