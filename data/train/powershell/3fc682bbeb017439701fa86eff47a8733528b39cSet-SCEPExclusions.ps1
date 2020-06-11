<#
.Synopsis
Script to set exclusions in SCEP
.DESCRIPTION
With this script you can set exclusions in SCEP and also clean the settings up with the -clean $true parameter.
.EXAMPLE
Set-SCEPExclusions.ps1 -XMLDir C:\temp\SCEP\EPTemplates\FEP_Default_Exchange.xml -CSVDir .\SCEP.csv -Computername SCSM01
1,SQL01
.EXAMPLE
.\Set-SCEPExclusions.ps1 -XMLDir C:\temp\SCEP\EPTemplates\FEP_Default_Exchange.xml -CSVDir -Computername SCSM01
.EXAMPLE
.\Set-SCEPExclusions.ps1 -XMLDir C:\temp\SCEP\EPTemplates\FEP_Default_Exchange.xml -CSVDir -Computername SCSM01 -Cleanup $true
#>
[CmdletBinding()]
param (
[Parameter(Mandatory=$False,
HelpMessage="Enter the path to XML File, always make sure your node names do not contain spaces")]
[AllowEmptyString()]
[String]$XMLDir,
[Parameter(Mandatory=$False,
HelpMessage="Enter the path to CSV File")]
[AllowEmptyString()]
[String]$CSVDir,
[Parameter(Mandatory=$True,
HelpMessage="Enter the Computers you want to manage")]
[String[]]$Computername,
[Parameter(Mandatory=$False,
HelpMessage='Delete all exclusions,value is $true or $False')]
[Bool]$Cleanup
)
If($XMLDir)
{
# load it into an XML object:
$xml = New-Object -TypeName XML
$xml.Load($XMLDir)
# note: if your XML is malformed, you will get an exception here
# always make sure your node names do not contain spaces
　
　
# simply traverse the nodes and select the information you want:
$get = $Xml.securitypolicy.PolicySection.LocalGroupPolicySettings.AddKey
}
#filter exclusions
$paths = $get|Where-Object {$_.name -like "*Paths"}
$Extensions = $get|Where-Object {$_.name -like "*Extensions"}
$Procesess = $get|Where-Object {$_.name -like "*Processes"}
if ($CSVDir)
{
$CSVInput = import-csv -Delimiter (";") -Path $CSVDir
}
#create exclusions Paths
$Path = @()
if ($paths.AddValue.name)
{
$Path += $Paths.AddValue.name
}
If ($CSVInput.path)
{
$Path += $CSVInput.path
}
#create exclusions Extensions
$Extension=@()
If ($Extensions.AddValue.name)
{
$Extension += $Extensions.AddValue.name
}
If ($CSVInput.extension)
{
$Extension += $CSVInput.extension
}
#Create exclusions Processes
$Proces = @()
IF ($Procesess.AddValue.name)
{
$Proces += $Procesess.AddValue.name
}
IF ($CSVInput.proces)
{
$Proces += $CSVInput.proces
}
　
　
Try
{
Write-output "Attempting to create new session"
$Session = New-PSSession -ComputerName $Computername -ErrorAction Stop
Write-output "Attempting to run invoke-command"
Invoke-Command -session $Session -ScriptBlock {param($Path,$Extension,$Proces,$Cleanup)
Write-output "Importing Module"
Import-Module “$env:ProgramFiles\Microsoft Security Client\MpProvider” -ErrorAction Stop
If($Cleanup -eq $True)
{
Remove-MProtPreference -ExclusionPath $Path -ExclusionExtension $Extension -ExclusionProcess $Proces
Clear-Variable -name Path,Extension,Proces
}
if ($Path) 
{
Set-MProtPreference -ExclusionPath $Path
}
　
if ($Extension)
{
Set-MProtPreference -ExclusionExtension $Extension
}
　
if ($Proces)
{
Set-MProtPreference -ExclusionProcess $Proces
}
} -Args $Path,$Extension,$Proces,$Cleanup
}
Catch
{
Write-output "caught a system exception"
Write-Warning $_.exception.message
}
Finally
{
Write-output "Disconnect sessions"
Disconnect-PSSession -Session $Session
}

