

Function Get-PDM {

$startLocation = Get-Location
$ver = (Get-Service | Where {$_.Name -like "AutoFORM PDM Archive*"})[-1].Name.Substring(21,5)
Write-Verbose -Message "GET PROCESSOR INFORMATION"
$ProcessorInfo = Get-WmiObject -Class Win32_Processor
If ($ProcessorInfo.DataWidth -eq "32")
{
	Write-Verbose -Message "32 BIT PROCESSOR DETECTED"
	$PDMLocation = "C:\Program Files\EFS Technology\PDM\Server_" + $ver + "\jboss-as-*.Final\standalone\configuration\"
	Write-Verbose -Message "CHANGE PDMLOCATION TO $pdmlocation"
}
ElseIf ($ProcessorInfo.DataWidth -eq "64")
{
	Write-Verbose -Message "64 BIT PROCESSOR DETECTED"
	$PDMLocation = "C:\Program Files (x86)\EFS Technology\PDM\Server_" + $ver + "\jboss-as-*.Final\standalone\configuration\"
	Write-Verbose -Message "CHANGE PDMLOCATION TO $pdmlocation"
}
Write-Verbose -Message "SET LOCATION TO $PDMLOCATION"
Set-Location $PDMLocation

Write-Verbose -Message "READ SETTINGS FILE"
$settings = Get-Content .\standalone.xml
Write-Verbose -Message "READ LOGGING LEVEL FROM SETTINGS"
$LoggingLevel = $settings[(Select-String -Path .\standalone.xml -Pattern "^\s*<logger category=\Wcom.efstech\W>").LineNumber].Split('"')[1]
Write-Verbose -Message "READ DB CONNECTION TIMEOUT FROM SETTINGS"
$DatabaseTimeout = $settings[(Select-String -Path .\standalone.xml -Pattern "^\s*<deployment-scanner path=\Wdeployments\W relative-to=\Wjboss.server.base.dir\W scan-interval=\W\d{4}\W deployment-timeout=\W\d*\W/>").LineNumber-1].Split('"')[-2]
Write-Verbose -Message "READ HTTP PORT FROM SETTINGS"
$HTTPPort = $settings[(Select-String -Path .\standalone.xml -Pattern "^\s*<socket-binding name=\Whttp\W port=\W\d*\W/>").LineNumber-1].Split('"')[-2]
Write-Verbose -Message "READ HTTPS PORT FROM SETTINGS"
$HTTPSPort = $settings[(Select-String -Path .\standalone.xml -Pattern "^\s*<socket-binding name=\Whttps\W port=\W\d*\W/>").LineNumber-1].Split('"')[-2]

Write-Verbose -Message "CREATE TABLE"
$table = New-Object system.Data.DataTable “PDM Configuration”
Write-Verbose -Message "DEFINE COLUMNS"
$col1 = New-Object system.Data.DataColumn HTTP_Port,([string])
$col2 = New-Object system.Data.DataColumn HTTPS_Port,([decimal])
$col3 = New-Object system.Data.DataColumn Logging_Level,([string])
$col4 = New-Object system.Data.DataColumn Database_Timeout,([string])
$col5 = New-Object system.Data.DataColumn Install_Path,([string])
Write-Verbose -Message "ADD COLUMNS TO TABLE"
$table.columns.add($col1)
$table.columns.add($col2)
$table.columns.add($col3)
$table.columns.add($col4)
$table.columns.add($col5)
Write-Verbose -Message "CREATE ROW"
$row = $table.NewRow()
Write-Verbose -Message "ASSIGN VALUES TO FIELDS IN ROW"
$row.HTTP_Port = $HTTPPort
$row.HTTPS_Port = $HTTPSPort
$row.Logging_Level = $LoggingLevel
$row.Database_Timeout = $DatabaseTimeout
$row.Install_Path = $PDMLocation
Write-Verbose -Message "ADD ROW TO TABLE"
$table.rows.add($row)

Write-Output "Autoform PDM $ver Configuration:"
$table | FL

Set-Location $startLocation

}