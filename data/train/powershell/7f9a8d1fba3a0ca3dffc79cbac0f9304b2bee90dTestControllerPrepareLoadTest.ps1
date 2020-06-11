param(
	[parameter(Mandatory = $true)]
	[String]$LoadTestRootPath,
	[parameter(Mandatory = $true)]
	[String]$SharePointServerName,
	[parameter(Mandatory = $true)]
	[String]$SPFarmSQLServerName,
	[parameter(Mandatory = $true)]
	[Int]$NumberOfUsers,
	[parameter(Mandatory = $true)]
	[String]$AdminUserName,
	[parameter(Mandatory = $true)]
	[String]$AdminPWD,
	[parameter(Mandatory = $true)]
	[int]$VSVersionNumber
)
Import-Module LogToFile

# Check if the given load test root folder exists
if(-not(Test-Path $LoadTestRootPath))
{
	LogToFile -Message "$($LoadTestRootPath) not found"
	throw [System.IO.FileNotFoundException] "$($LoadTestRootPath) not found"
}

# Sub path variables
$initScriptSubPath = "SharePointLoadTest\Init.ps1"
$slnSubPath = "SharePointLoadTest.sln"
$VSKeyName = "VS$($VSVersionNumber)0COMNTOOLS"
$CommonToolsPath = (Get-ChildItem Env:$VSKeyName).Value
$CommonSevenPath = Split-Path $CommonToolsPath -Parent
$devenvSubPath = "IDE\devenv.exe"

# Paths
$initScriptPath = Join-Path $LoadTestRootPath $initScriptSubPath
$slnPath = Join-Path $LoadTestRootPath $slnSubPath
$devenvPath = Join-Path $CommonSevenPath $devenvSubPath

# Other variables
$Domain = (Get-CimInstance -ClassName Win32_ComputerSystem).Domain
$spFQDN = "$($SharePointServerName).$($Domain)"
$sqlSrvFQDN = "$($SPFarmSQLServerName).$($Domain)"
$tcFQDN = "$($env:ComputerName).$($Domain)"

# Check if init script exists on the expected path
if(-not(Test-Path $initScriptPath))
{
	LogToFile -Message "$($initScriptPath) not found"
	throw [System.IO.FileNotFoundException] "$($initScriptPath) not found"
}

# Check if the solution file exists on the expected path
if(-not(Test-Path $slnPath))
{
	LogToFile -Message "$($slnPath) not found"
	throw [System.IO.FileNotFoundException] "$($slnPath) not found"
}

# Call init script 
try
{
	LogToFile -Message "Setting endpoints on the load test package"
	$secpasswd = ConvertTo-SecureString $AdminPWD -AsPlainText -Force
	$adminCreds = New-Object System.Management.Automation.PSCredential ("$($Domain)\$($AdminUserName)", $secpasswd)
	$session = New-PSSession -Credential $adminCreds
	Invoke-Command -Session $session -ScriptBlock {param($script,$spServ,$sqlServ,$tc,$nUsers) & $script -FrontendServers $spServ -SQLServers $sqlServ -Controller $tc -TotalUserCount $nUsers} `
	-ArgumentList $initScriptPath,$spFQDN,$sqlSrvFQDN,$tcFQDN,$NumberOfUsers
}
catch
{
	LogToFile -Message "ERROR:Execution of the set load test endpoints script failed"
	throw [System.Exception] "Execution of the set load test endpoints script failed"
}
finally
{
	if($session)
	{
		Remove-PSSession -Session $session
	}
}
LogToFile -Message "Done setting enpoints"

# Build load test solution
LogToFile -Message "Building load test solution"
$buildParams = """$slnPath"" /Build Release"
$process = [System.Diagnostics.Process]::Start( "$devenvPath", $buildParams )
$process.WaitForExit()
LogToFile -Message "Done building"
