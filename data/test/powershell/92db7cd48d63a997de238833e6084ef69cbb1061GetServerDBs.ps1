# Test to see if the SQLPS module is loaded, and if not, load it
if (-not(Get-Module -name 'SQLPS')) {
  if (Get-Module -ListAvailable | Where-Object {$_.Name -eq 'SQLPS' }) {
    Push-Location # The SQLPS module load changes location to the Provider, so save the current location
	Import-Module -Name 'SQLPS' -DisableNameChecking
	Pop-Location # Now go back to the original location
    }
  }

# Connect to the specified instance
$srcinst = 'NJ1SQL08DMADEV\SQL_DMADEV01'
$srv = new-object ('Microsoft.SqlServer.Management.Smo.Server') $srcinst
$srv.ConnectionContext.StatementTimeout = 0
$dbs = $srv.Databases
$bdir = $workdir 