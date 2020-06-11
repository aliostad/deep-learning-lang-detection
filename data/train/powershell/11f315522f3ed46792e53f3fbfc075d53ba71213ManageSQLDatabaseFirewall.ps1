
<#
.SYNOPSIS
    Manage SQL Server database and firewall rules
.DESCRIPTION
    Script will walk you through changing size and type of a database along with setting and removing firewall rules

#>


# Setting up the subscription info and the certificate
# to be used when connecting to the subscription
# 
# This needs to be done once per subscription on each 
# new client machine
# Enter values for thumbprint and subscription ID
$thumbprint = "Enter thumbprint Here"
$myCert = Get-Item cert:\\CurrentUser\My\$thumbprint
$subID = "Enter SUBid Here"
Set-AzureSubscription -SubscriptionName "Example" -SubscriptionId $subID -Certificate $myCert

#Example
#$thumbprint = "0000000000000000000000000000000000000000"
#$myCert = Get-Item Cert:\CurrentUser\My\$thumbprint
#$subId = "00000000-0000-0000-0000-000000000000"


# Select the active subscription to be used 
# for the rest of the script
#
Select-AzureSubscription -SubscriptionName "Example"
Get-AzureSubscription

# See all servers in the subscription
Get-AzureSqlDatabaseServer

# Assign server
$server = Get-AzureSqlDatabaseServer "DemoServer"


###########Manage Firewall Rules on a server#################


# Get all firewall rules in all servers in subscription
Get-AzureSqlDatabaseServer | Get-AzureSqlDatabaseServerFirewallRule

# Add a new firewall rule : This rule opens all IPs to the server and is just an example - not recommended
$server | New-AzureSqlDatabaseServerFirewallRule -RuleName AllOpen -StartIPAddress 0.0.0.0 -EndIPAddress 255.255.255.255


# Get all firewall rules in all servers in subscription
Get-AzureSqlDatabaseServer | Get-AzureSqlDatabaseServerFirewallRule

# Add a new firewall rule : This gets all the fireWall rules in the server named jt6ocnuuln and adds them to the new database server
$fwRules = Get-AzureSqlDatabaseServer -ServerName jt6ocnuuln | Get-AzureSqlDatabaseServerFirewallRule
foreach ($fwRule in $fwRules)
    { $server | New-AzureSqlDatabaseServerFirewallRule -RuleName $fwRule.RuleName -StartIpAddress $fwRule.StartIpAddress -EndIpAddress $fwRule.EndIpAddress }


# Create a new rule that allows all Azure Service to access the server
New-AzureSqlDatabaseServerFirewallRule -ServerName "fk1ucgo5xr" -RuleName "myRule" -AllowAllAzureServices

# Create a new rule that allows all Azure Service to access the server by piping in server object
$Server | New-AzureSqlDatabaseServerFirewallRule -AllowAllAzureServices


# Check the firewall rules again
Get-AzureSqlDatabaseServer | Get-AzureSqlDatabaseServerFirewallRule

# Remove all 'FirewallRules' rule from all servers in subscription
Get-AzureSqlDatabaseServer | Get-AzureSqlDatabaseServerFirewallRule -RuleName FirewallRules | Remove-AzureSqlDatabaseServerFirewallRule -WhatIf
Get-AzureSqlDatabaseServer | Get-AzureSqlDatabaseServerFirewallRule


###########Manage SQL Server and Databases#################


# Connect to the server using Sql Authentication
#
$servercredential = new-object System.Management.Automation.PSCredential("mylogin", ("Sql@zure"  | ConvertTo-SecureString -asPlainText -Force))
$ctx = $server | New-AzureSqlDatabaseServerContext -Credential $serverCredential

# List databases
#
Get-AzureSqlDatabase $ctx

# Create a new database
#
$db = New-AzureSqlDatabase $ctx -DatabaseName Demo
Get-AzureSqlDatabase $ctx

# Change database maximum size
Set-AzureSqlDatabase $ctx $db -MaxSizeGB 10
Get-AzureSqlDatabase $ctx

# Remove the database
$db | Remove-AzureSqlDatabaseServer

# Remove the server
#
$server | Remove-AzureSqlDatabaseServer

# Aleternatively to creating a SQL authentication contect you can also create a database with certifcate authentication
# Create context using certifcate authentication with Subscription information
$servercertctx = New-AzureSqlDatabaseServerContext -ServerName "exampleserver" -UseSubscription
Get-AzureSqlDatabase $servercertctx 

# Create a new database using cert auth - $server created above
#
$server | New-AzureSqlDatabase -DatabaseName "example"
$server | Remove-AzureSqlDatabase -DatabaseName "example"
$server | Get-AzureSqlDatabase -DatabaseName "example"

# Create a new database using cert auth from ctx created with certificate authentication 
#
$servercertctx | New-AzureSqlDatabase -DatabaseName "example"
$servercertctx | Remove-AzureSqlDatabase -DatabaseName "example"
$servercertctx | Get-AzureSqlDatabase -DatabaseName "example"
