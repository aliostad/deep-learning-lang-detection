function Start-Migration {
[CmdletBinding()]
Param(
    
)	
	function ExecuteSqlScript($path){			
		Import-Module PsSql
		if ( -not ($state.ConnectionString ) ){
			Invoke-Sql $_.FullName
		} else {
			Invoke-Sql $_.FullName -ConnectionString ( $state.ConnectionString )
		}
	}   	
		
	# Actual execution
    $state = Load-MigrationState
	    
    $runNextMigration = ( $state.LastMigration -eq $null )
    Get-ChildItem *.ps1 | where-object {$_.Extension -match ".ps1|.sql" } | sort Name | %{
		$migrationName = ($_.Name)
        if ($runNextMigration){
            Write-Host "Running migration $migrationName"
            Write-Verbose "Migration full path is $_"			
			if ($_.Extension -eq ".sql" ) {
            	# Let's execute 
				Import-Module PsSql
				Invoke-Sql $_.FullName
			} else {
				& $_.FullName
			}
            Write-Verbose "Migration $migrationName compelted"
            $state.LastMigration = $migrationName
        }
        if ($migrationName -eq $state.LastMigration){
            $runNextMigration = $true
        }
    }
    
    Store-MigrationState $state
    
<#
.Synopsis
    Migrate stuff from current directory.
.Description
.Example
    Start-Migration

    Description
    -----------
    Starts migration

#>
}
function Update-MigrationConfig {
[CmdletBinding()]
Param(    
	[String]$ConnectionString
)
	$state = Load-MigrationState
	
	if ($ConnectionString){
		$state.ConnectionString = $ConnectionString
	}
	
	Store-MigrationState($state)
<#
.Synopsis
    Setup local migraiton configuration
.Description
.Parameter ConnectionString
    Optional paramter for connection string that command will use to excute script, by default connection string is to local default server and windows authentication.
.Example
    Update-MigrationConfig -ConnectionString "Server = FOO;Integrated Security=True"

    Description
    -----------
    Setup migration to use given connection string

#>
}

function Store-MigrationState($state){
	$buffer = New-Object Text.StringBuilder
    foreach($key in $state.Keys){			
        $buffer.AppendLine( $key + "=" + $state[$key] ) | Out-Null  
    }
	Set-Content ".PsMigrator" ( $buffer.ToString() )	
}

function Load-MigrationState(){
	if (Test-Path .PsMigrator) {       
		Write-Verbose "Load migration state from .PsMigrator file"
		$psMigratorFullPath = Resolve-Path .PsMigrator
		return ConvertFrom-StringData ([IO.File]::ReadAllText($psMigratorFullPath))    
	}	
	return @{}
}

Export-ModuleMember Start-Migration
Export-ModuleMember Update-MigrationConfig
