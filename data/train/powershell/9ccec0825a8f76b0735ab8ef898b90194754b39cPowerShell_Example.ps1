# Assign SSIS namespace to variable
$ssisNamespace = "Microsoft.SqlServer.Management.IntegrationServices"

# Load the SSIS Management Assembly
$assemblyLoad = [Reflection.Assembly]::Load($ssisNamespace + ", Version=11.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91")

# Create a connection to a SQL Server instance
$connectionString = "Data Source=localhost;Initial Catalog=master;Integrated Security=SSPI;"
$connection = New-Object System.Data.SqlClient.SqlConnection $connectionString

# Instantiate the SSIS object
$ssis = New-Object $ssisNamespace".IntegrationServices" $connection

# Instantiate the SSIS package
$catalog = $ssis.Catalogs["SSISDB"]
$folder = $catalog.Folders["TK 463 Chapter 11"]
$project = $folder.Projects["TK 463 Chapter 10"]
$package = $project.Packages[“Master.dtsx”]

# Set package parameter(s)
$catalog.ServerLoggingLevel = [Microsoft.SqlServer.Management.IntegrationServices.Catalog+LoggingLevelType]::Verbose
$catalog.Alter()

# Execute SSIS package ($environment is not assigned)
$executionId = $package.Execute("false", $environment)
