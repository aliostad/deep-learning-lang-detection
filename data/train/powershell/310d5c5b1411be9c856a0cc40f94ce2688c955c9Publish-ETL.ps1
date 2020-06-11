Param(
	[Parameter(Mandatory=$True,ValueFromPipeline=$True)][object]$computers
)

Process
{
    Foreach ($computer in $computers) 
	{
        if ($computer.session -eq $null)
        {
	        Write-Host "`n`n($($computer.defaultHost)) is missing "T"he remote session connection"
	        exit;
        }
		
		if (!($computer.features -contains "sql"))
		{
			Write-Host "SQL services not installed, skipping..." -fore yellow
			Write-Output $_
			Continue;
        }
		
		$etlScript = Get-Content "Publish-ETL.sql" | Out-String

		if (Test-Path "\\$($computer.defaultHost)\c$\ETL")
		{
			Remove-Item "\\$($computer.defaultHost)\c$\ETL" -recurse -force -ErrorAction SilentlyContinue | Out-Null
		}

		New-Item -type Directory "\\$($computer.defaultHost)\c$\ETL"  | Out-Null
		Copy-Item "..\..\Platform\Database\ETL\ETL\*.dtsx" "\\$($computer.defaultHost)\c$\ETL\" -force 
		
        Invoke-Command -Session $computer.session -ScriptBlock {
			param ([string]$etlScript)
			
	        Write-Host "`Updating ETL on $(hostname)" -fore cyan
			Write-Debug "Loading SMO Assemblies"
			
			Add-PSSnapin SqlServerCmdletSnapin100 | Out-Null
			Add-PSSnapin SqlServerProviderSnapin100 | Out-Null
		
			[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo")
			[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SqlEnum")
			[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SmoEnum")
			[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.ConnectionInfo")
			[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SmoExtended")
			
			$output = Invoke-Sqlcmd -Query $etlScript -ServerInstance "localhost" -Database "master" -U "sa"-P "r9a8b8k1$" -OutputSqlErrors $true | Write-Host
			Write-Host $output
			
        } -ArgumentList $etlScript | Out-Null
		

        Write-Output $_
    }
}