# Managing SQL Databases

# Create a SQL Database server connection context to a specified srever

# Define a SQL Database server credential - Specify the username, and password in the Popup diagnos
$cred = Get-Credential
# If you authenticated without specifying a domain, then if you are using PowerShell 2.0, the Get-Credential cmdlet returns a backslash prepended to the username, for example, "\user" (PowerShell 3.0 does not add the backslash). 
# This backslash is not recognized by the -Credential parameter of the New-AzureSqlDatabaseServerContext cmdlet. To remove it, use code similar to the following: (from http://msdn.microsoft.com/en-us/library/windowsazure/jj871050.aspx)
$cred = New-Object -TypeName 'System.Management.Automation.PSCredential' -ArgumentList $cred.Username.Replace("\",""),$cred.Password

# Here is another method to create the credentil by specifying username and password in plain text
$db_user = "my_login_name"
$db_password = ConvertTo-SecureString -String "my_password" -AsPlainText -Force
$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $db_user, $db_password

$sqlDatabaseServerName = "syiiwwahe7"
$sqlDatabaseServerNameFQDN = "syiiwwahe7.database.windows.net"
$sqlDatabaseServerManagementURL = "https://syiiwwahe7.database.windows.net"

$icx = New-AzureSqlDatabaseServerContext -ServerName $sqlDatabaseServerName -Credential $cred

# We can also create context using FQDN and Management URL properties
$icx_fqdn = New-AzureSqlDatabaseServerContext -FullyQualifiedServerName $sqlDatabaseServerNameFQDN -Credential $cred
$icx_mgmt_url = New-AzureSqlDatabaseServerContext -ManageUrl $sqlDatabaseServerManagementURL -Credential $cred

# Retrieve all databases
Get-AzureSqlDatabase -Context $icx

# Create a new database
New-AzureSqlDatabase -Context $icx -DatabaseName "MyDB" -MaxSizeGB 50 -Edition Business -Collation "SQL_Latin1_General_CP1_CI_AS" -Force

# Update a database
Set-AzureSqlDatabase -Context $icx -DatabaseName "MyDB" -NewName "MyDB_New" -MaxSizeGB 150 -Force

# Remove a database
Remove-AzureSqlDatabase -Context $icx -DatabaseName "MyDB_New" -Force
