# Enable Remote DAC configuration setting on the SQL Server instance
 
# Import the SQLPS module
Import-Module sqlps -DisableNameChecking
# Prepare the T-SQL script to be executed against the SQL Server instance
$TSQLScript = "
-- Enable advanced options
exec sp_configure 'show advanced options',1;
reconfigure with override
-- Enabled remote DAC connections
exec sp_configure 'remote admin connections',1;
reconfigure with override"
# Execute the T-SQL script against the SQL Server instance
Invoke-SqlCmd -ServerInstance . -Query $TSQLScript -Database "master"
