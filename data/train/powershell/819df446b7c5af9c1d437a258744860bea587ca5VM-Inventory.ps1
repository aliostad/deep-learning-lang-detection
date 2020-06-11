#requires -version 4
<#
.SYNOPSIS
  v1.0 Collect VM basic info from host or vCenter. No filtering capabilities at this time.
  v1.1 Added vCenter/Host License information.
  v1.2 Added to Git
.DESCRIPTION
  PowerShell script to gather VMs in vCenter/Host and email list
.PARAMETER <Parameter_Name>
  <Brief description of parameter input required. Repeat this attribute if required>
.INPUTS
  <Inputs if any, otherwise state None>
.OUTPUTS Log File
  The script log file stored in C:\Windows\Temp\<name>.log
.NOTES
  Version:        1.1
  Author:         Ricardo Londono
  Creation Date:  9/8/2016
  Purpose/Change: Initial script development
.EXAMPLE
  <Example explanation goes here>

  <Example goes here. Repeat this attribute for more than one example>
#>

#---------------------------------------------------------[Script Parameters]------------------------------------------------------

Param (
  #Script parameters go here
)

#---------------------------------------------------------[Initialisations]--------------------------------------------------------

#Set Error Action to Silently Continue
#$ErrorActionPreference = 'Stop'

# Path where script is being executed.
$ScriptPath = $PSCommandPath

#Import Modules & Snap-ins
Import-Module $ScriptPath\..\PSLogging.psd1


# Assembly for user input
[void][Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')

# Assembly for popup
Add-Type -AssemblyName PresentationCore,PresentationFramework

# now we must check for PowerCLI Module
if (Get-Module -ListAvailable -Name VMware.VimAutomation.Common) {
	Import-Module -Name VMware.VimAutomation.Common
} else {
    $MessageBody = "You are missing the VMware.VimAutomation.Common Module. `n`nPlease install VMware-PowerCLI-6.3 or newer and try again."
    Write-LogInfo -LogPath $sLogFile -Message $MessageBody
    $ButtonType = [System.Windows.MessageBoxButton]::OK
    $MessageIcon = [System.Windows.MessageBoxImage]::Error
    $MessageTitle = "Error has occurred"
    $Result = [System.Windows.MessageBox]::Show($MessageBody,$MessageTitle,$ButtonType,$MessageIcon)
    Break
}

if (Get-Module -ListAvailable -Name VMware.VimAutomation.Core) {
	Import-Module -Name VMware.VimAutomation.Core
} else {
    $MessageBody = "You are missing the VMware.VimAutomation.Core Module. `n`nPlease install VMware-PowerCLI-6.3 or newer and try again."
    Write-LogInfo -LogPath $sLogFile -Message $MessageBody
    $ButtonType = [System.Windows.MessageBoxButton]::OK
    $MessageIcon = [System.Windows.MessageBoxImage]::Error
    $MessageTitle = "Error has occurred"
    $Result = [System.Windows.MessageBox]::Show($MessageBody,$MessageTitle,$ButtonType,$MessageIcon)
    Break
}

#----------------------------------------------------------[Declarations]----------------------------------------------------------

#Script Version
$sScriptVersion = '1.0'

#Log File Info
$sLogPath = 'C:\Windows\Temp'
$sLogName = 'vSphere-VM-Inventory.log'
$sLogFile = Join-Path -Path $sLogPath -ChildPath $sLogName
$sVMList = 'VMList.csv'
$sVMLicense = 'VMLicense.csv'
$sVMListExcel = 'VMList.xlsx'

# Get server and user login
$title = 'vSphere Environment'
$msg1   = 'Enter vCenter or Host FQDN'
$Server = [Microsoft.VisualBasic.Interaction]::InputBox($msg1, $title)
$cred = Get-Credential -Message "Enter vCenter or Host login information"

#-----------------------------------------------------------[Functions]------------------------------------------------------------

# CSV to Excel multiple sheets function
Function Merge-CSVFiles
{
	Param(
	$CSVPath = "C:\CSV", ## Soruce CSV Folder
	$XLOutput="c:\temp.xlsx" ## Output file name
	)

	$csvFiles = Get-ChildItem ("$CSVPath\*") -Include *.csv
	$Excel = New-Object -ComObject excel.application 
	$Excel.visible = $false
	$Excel.sheetsInNewWorkbook = $csvFiles.Count
	$workbooks = $excel.Workbooks.Add()
	$CSVSheet = 1

	Foreach ($CSV in $Csvfiles)
		{
		$worksheets = $workbooks.worksheets
		$CSVFullPath = $CSV.FullName
		$SheetName = ($CSV.name -split "\.")[0]
		$worksheet = $worksheets.Item($CSVSheet)
		$worksheet.Name = $SheetName
		$TxtConnector = ("TEXT;" + $CSVFullPath)
		$CellRef = $worksheet.Range("A1")
		$Connector = $worksheet.QueryTables.add($TxtConnector,$CellRef)
		$worksheet.QueryTables.item($Connector.name).TextFileCommaDelimiter = $True
		$worksheet.QueryTables.item($Connector.name).TextFileParseType  = 1
		$worksheet.QueryTables.item($Connector.name).Refresh()
		$worksheet.QueryTables.item($Connector.name).delete()
		$worksheet.UsedRange.EntireColumn.AutoFit()
		$CSVSheet++
		}
	$workbooks.SaveAs($XLOutput,51)
	$workbooks.Saved = $true
	$workbooks.Close()
	[System.Runtime.Interopservices.Marshal]::ReleaseComObject($workbooks) | Out-Null
	$excel.Quit()
	[System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel) | Out-Null
	[System.GC]::Collect()
	[System.GC]::WaitForPendingFinalizers()
}

#-----------------------------------------------------------[Execution]------------------------------------------------------------

Start-Log -LogPath $sLogPath -LogName $sLogName -ScriptVersion $sScriptVersion
Try
{
    # Try to connect to server
    Write-LogInfo -LogPath $sLogFile -Message 'Connect to vCenter or ESXi Host.'
    Connect-VIServer -Server $Server -User $cred.GetNetworkCredential().username -Password $cred.GetNetworkCredential().password -ErrorAction Stop

	# Popup window Begin collection
	$MessageBody = "Starting Data Collection.`nPlease be patient as this could take few minutes.`n`nPlease click OK to continue."
    Write-LogInfo -LogPath $sLogFile -Message $MessageBody
    $ButtonType = [System.Windows.MessageBoxButton]::OK
    $MessageIcon = [System.Windows.MessageBoxImage]::Information
    $MessageTitle = "Start Collection - Please click OK to continue."
    $Result = [System.Windows.MessageBox]::Show($MessageBody,$MessageTitle,$ButtonType,$MessageIcon)

    # Assume succesful connection and begin work.
    Write-LogInfo -LogPath $sLogFile -Message 'List VMs on Host or vCenter.'
    $VMList = Get-VM | Select Name, Guest, NumCPU, MemoryGB, Version, VMHost
	# Get License view information
	$si = Get-View ServiceInstance
	$LicManRef = $si.Content.LicenseManager
	$LicManView = Get-View $LicManRef
	$VMLicense = $LicManView.Licenses
	# Export CSV's
	$VMList | Export-Csv -Path $sLogPath'\'$sVMList -NoTypeInformation -Encoding UTF8 -Force
	sleep -Seconds 1
	$VMLicense | Export-Csv -Path $sLogPath'\'$sVMLicense -NoTypeInformation -Encoding UTF8 -Force
	sleep -Seconds 1
	# Write Excel
	Merge-CSVFiles -CSVPath $sLogPath -XLOutput $sLogPath'\'$sVMListExcel

	# Popup window finished.
	$MessageBody = "Finished Collecting VM Info`n`nFile location: $sLogPath\$sVMListExcel"
    Write-LogInfo -LogPath $sLogFile -Message $MessageBody
    $ButtonType = [System.Windows.MessageBoxButton]::OK
    $MessageIcon = [System.Windows.MessageBoxImage]::Information
    $MessageTitle = "Finished Collection"
    $Result = [System.Windows.MessageBox]::Show($MessageBody,$MessageTitle,$ButtonType,$MessageIcon)
}
Catch
{
    $ErrorMessage = $_.Exception.Message
    Write-LogInfo -LogPath $sLogFile -Message $ErrorMessage
    $ButtonType = [System.Windows.MessageBoxButton]::OK
    $MessageIcon = [System.Windows.MessageBoxImage]::Error
    $MessageBody = "$ErrorMessage"
    $MessageTitle = "Error has occurred"
    $Result = [System.Windows.MessageBox]::Show($MessageBody,$MessageTitle,$ButtonType,$MessageIcon)
    Break
}
Stop-Log -LogPath $sLogFile
