###
# Script for database change management
# Author: Mikael Lundin
# Website: http://mint.litemedia.se
# E-mail: mikael.lundin@litemedia.se
#
###
# Drop-Database
# Will remove a database from the DBMS
#
###
# Build-Database
# Will create database in the DBMS and the mandatory Settings table
#
###
# Update-Database
# Will bring the database up to the most recent version
# 
###


# Will drop the database if it exists
Function Drop-Database ([string]$sql_server, [string]$database_name)
{
	try {
		[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SMO')  | out-null
		$s = new-object ('Microsoft.SqlServer.Management.Smo.Server') $sql_Server
		$s.Refresh();
		$s.KillDatabase($database_name);
		Write-Host "Killed database $databaseName"
	}
	catch {
		Write-Host "Tried to delete database $databaseName but failed, probably because it did not exist"
	}
}

# Will update the database to the most current version in the database directory
Function Update-Database ([string]$connection_string, [string]$database_directory)
{

	$databaseVersion = Get-Database-Version $connection_string
	
	# Get all source files that have higher database version number
	$files = Get-ChildItem "$database_directory\*.sql" | Where { [int]::Parse($_.name.Substring(0, 4)) -gt $databaseVersion }
	
	# For each of those files, run query on database
	foreach ($file in $files)
	{
		$fileName = $file.name
		Write-Host "Apply update script: $fileName"
		
		# Get-Content returns a string array of all the lines. We join that into a single string
		$fileContents = Get-Content "$file"
		$sql = [string]::Join([Environment]::NewLine, $fileContents);
		Execute-Sql-Query $connectionString $sql
		
		# Get this version number
		$version = [int]::Parse($fileName.Substring(0, 4))
	
		# Update the settings database with current version number
		Execute-Sql-Query $connectionString "UPDATE [Settings] SET [DatabaseVersion] = $version"
	}
}

# Will create a new database and add table to manage versions
Function Build-Database ([string]$sqlServer, [string]$databaseName)
{
	# http://sqlblog.com/blogs/allen_white/archive/2008/04/28/create-database-from-powershell.aspx
	[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SMO')  | out-null
	$s = new-object ('Microsoft.SqlServer.Management.Smo.Server') $sqlServer
	$dbname = $databaseName
	
	# Instantiate the database object and create database
	$db = new-object ('Microsoft.SqlServer.Management.Smo.Database') ($s, $dbname)
	$db.Create()
	
	# Create table and column for handling database version
	$db.ExecuteNonQuery("CREATE TABLE [$databaseName].[dbo].[Settings] ([DatabaseVersion] int NOT NULL)");
	$db.ExecuteNonQuery("INSERT INTO [$databaseName].[dbo].[Settings] ([DatabaseVersion]) VALUES (0)");
}

# Helper functions
Function Get-Database-Version ([string]$connectionString)
{
	[System.Data.SqlClient.SqlConnection]::ClearAllPools()

	$sql = "SELECT TOP 1 [DatabaseVersion] FROM [Settings]"
	## Connect to the data source and open it
	$connection = New-Object System.Data.SqlClient.SqlConnection $connectionString
	$connection.Open()

	$command = New-Object System.Data.SqlClient.SqlCommand $sql,$connection
	$version = $command.ExecuteScalar();
	
	$connection.Close()
	$version
}

Function Validate-Connection ([string]$connectionString)
{
	[System.Data.SqlClient.SqlConnection]::ClearAllPools()
	
	try	{
		## Connect to the data source and open it
		$connection = New-Object System.Data.SqlClient.SqlConnection $connectionString
		$connection.Open()
		$connection.Close()
		$TRUE
	}
	catch {
		$FALSE
	}
}

Function Execute-Sql-Query ([string]$connectionString, [string]$sql)
{
	[System.Data.SqlClient.SqlConnection]::ClearAllPools()
	
	## Connect to the data source and open it
	$connection = New-Object System.Data.SqlClient.SqlConnection $connectionString
	$connection.Open()

	$command = New-Object System.Data.SqlClient.SqlCommand $sql,$connection
	$result = $command.ExecuteNonQuery();
	
	$connection.Close()
}