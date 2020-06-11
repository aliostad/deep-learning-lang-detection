[reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo") | Out-Null
[reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.SqlWmiManagement") | Out-Null

$server = $env:COMPUTERNAME
$instance = 'SQL2014'
$smo = 'Microsoft.SqlServer.Management.Smo.'
$wmi = new-object ($smo + 'Wmi.ManagedComputer')

# Enable TCP/IP
$uri = "ManagedComputer[@Name='$server']/ServerInstance[@Name='$instance']/ServerProtocol[@Name='Tcp']"
$tcp = $wmi.GetSmoObject($uri)
$tcp.IsEnabled = $true
$tcp.alter()

# Enable named pipes
$uri = "ManagedComputer[@Name='$server']/ServerInstance[@Name='$instance']/ServerProtocol[@Name='Np']"
$np = $wmi.GetSmoObject($uri)
$np.IsEnabled = $true
$np.Alter()

# Start services
Set-Service SQLBrowser -StartupType Manual
Start-Service SQLBrowser
# Start-Service "MSSQL`$$instance"
Restart-Service "MSSQL`$$instance"

# Restart SQL Server
# $sqlserver = $wmi.Services["MSSQL`$$instance"]
# $sqlserver
# $sqlserver.Stop();
# $sqlserver.Refresh(); 
# $sqlserver
# $sqlserver.Start();
# $sqlserver.Refresh(); 
# $sqlserver



# $sqlbrowser = $Wmi.Services["SQLBrowser"]
# $sqlbrowser
# $sqlbrowser.Start();
# $sqlbrowser.Refresh(); 
# $sqlbrowser
