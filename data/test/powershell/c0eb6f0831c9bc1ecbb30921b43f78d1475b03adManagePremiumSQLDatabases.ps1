
<#
.SYNOPSIS
    Manage Premium SQL Databases
.DESCRIPTION
    Script will walk you through checking premium quota and managing premium database reservations.

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


######Check Premium database quota.########################### 

# This command will list if you have been assigned premium quota. Premium database quota must be requested for your server via the Windows Azure Management Portal

Get-AzureSqlDatabaseServerQuota $ctx

$ctx | Get-AzureSqlDatabaseServerQuota



########Change reservation size of a Premium database.########################### 


$servercredential = new-object System.Management.Automation.PSCredential("mylogin", ("Sql@zure"  | ConvertTo-SecureString -asPlainText -Force))
$ctx = $server | New-AzureSqlDatabaseServerContext -Credential $serverCredential

# Get an enabled service objective
$objective = Get-AzureSqlDatabaseServiceObjective -Context $ctx -ServiceObjectiveName "Reserved P2"
$objective


# Assign a diffent service objective to a database NOTE: This may take a long time to complete
Set-AzureSqlDatabase -ConnectionContext $ctx -DatabaseName "testdb" -ServiceObjective $objective


$ctx | Get-AzureSqlDatabase -DatabaseName "testdb"


########Downgrade database from Permium to Shared.########################### 


$servercredential = new-object System.Management.Automation.PSCredential("mylogin", ("Sql@zure"  | ConvertTo-SecureString -asPlainText -Force))
$ctx = $server | New-AzureSqlDatabaseServerContext -Credential $serverCredential

# Get an enabled service objective
$objective = Get-AzureSqlDatabaseServiceObjective -Context $ctx -ServiceObjectiveName "Shared"
$objective


# Assign a diffent service objective to a database NOTE: This may take a long time to complete
Set-AzureSqlDatabase -ConnectionContext $ctx -DatabaseName "testdb" -ServiceObjective $objective


$ctx | Get-AzureSqlDatabase -DatabaseName "testdb"