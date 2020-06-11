#-------------------------------------------------------------------------
# Configuration script exit code definition:
# 1. A normal termination will set the exit code to 0
# 2. An uncaught THROW will set the exit code to 1
# 3. Script execution warning and issues will set the exit code to 2
# 4. Exit code is set to the actual error code for other issues
#-------------------------------------------------------------------------

#----------------------------------------------------------------------------
# <param name="unattendedXmlName">The unattended SUT configuration XML.</param>
#----------------------------------------------------------------------------
param(
[string]$unattendedXmlName
)

#-----------------------------------------------------
# Import the Common Function Library File
#-----------------------------------------------------
$scriptDirectory = Split-Path $MyInvocation.Mycommand.Path 
$commonScriptDirectory = $scriptDirectory.SubString(0,$scriptDirectory.LastIndexOf("\")+1) +"Common"       
.("$commonScriptDirectory\SharePointCommonConfiguration.ps1")
.("$commonScriptDirectory\CommonConfiguration.ps1")

#----------------------------------------------------------------------------
# Starting script
#----------------------------------------------------------------------------
$ErrorActionPreference = "Stop"
[String]$containerPath = Get-Location
$logPath               = $containerPath + "\SetupLogs"
$logFile               = $logPath+"\SharePointSecondSUTConfiguration.ps1.log"
$debugLogFile          = $logPath+"\SharePointSecondSUTConfiguration.ps1.debug.log"
if(!(Test-Path $logPath))
{
    New-Item $logPath -ItemType directory
}elseif([System.IO.File]::Exists($logFile))
{
    Remove-Item $logFile -Force
}
Start-Transcript $debugLogFile -force
AddTimesStampsToLogFile "Start" "$logFile"
#----------------------------------------------------------------------------
# Default Values for Configuration 
#----------------------------------------------------------------------------
$environmentResourceFile                     = "$commonScriptDirectory\SharePointTestSuite.config"

$MSCOPYSSiteCollectionName                   = ReadConfigFileNode "$environmentResourceFile" "MSCOPYSSiteCollectionName"
$MSCOPYSSubSite                              = ReadConfigFileNode "$environmentResourceFile" "MSCOPYSSubSite"
$MSCOPYSSourceDocumentLibrary                = ReadConfigFileNode "$environmentResourceFile" "MSCOPYSSourceDocumentLibrary"
$MSCOPYSTextFieldName                        = ReadConfigFileNode "$environmentResourceFile" "MSCOPYSTextFieldName"
$MSCOPYSWorkFlowEventFieldName               = ReadConfigFileNode "$environmentResourceFile" "MSCOPYSWorkFlowEventFieldName"
$MSCOPYSSourceLibraryFieldValue              = ReadConfigFileNode "$environmentResourceFile" "MSCOPYSSourceLibraryFieldValue"
$MSCOPYSTestData                             = ReadConfigFileNode "$environmentResourceFile" "MSCOPYSTestData"

#-----------------------------------------------------
# Check whether the unattended SUT configuration XML is available if run in unattended mode.
#-----------------------------------------------------
if($unattendedXmlName -eq "" -or $unattendedXmlName -eq $null)
{    
    Output "The SUT setup script will run in attended mode." "White"
}
else
{    
    While($unattendedXmlName -ne "" -and $unattendedXmlName -ne $null)
    {   
        if(Test-Path $unattendedXmlName -PathType Leaf)
        {
            Output "The SUT setup script will run in unattended mode with information provided by the `"$unattendedXmlName`" file." "White"
            $unattendedXmlName = Resolve-Path $unattendedXmlName
            break
        }
        else
        {
            Output "The SUT configuration XML path `"$unattendedXmlName`" is not correct." "Yellow"
            Output "Retry with the correct file path or press `"Enter`" if you want the SUT setup script to run in attended mode." "Cyan"
            $unattendedXmlName = Read-Host
        }
    }
}

#-----------------------------------------------------
# Start to automatic services required by test case
#-----------------------------------------------------
iisreset /restart
StartService "MSSQL*" "Auto"

#-----------------------------------------------------
# Begin to configure second server
#-----------------------------------------------------
Output "Begin to configure server ..." "White"

Output "Steps for manual configuration:" "Yellow" 
Output "Enable remoting in PowerShell." "Yellow"
Invoke-Command {
    $ErrorActionPreference = "Continue"
    Enable-PSRemoting -Force
}

[int]$recommendedMaxMemory = 1024
Output "Steps for manual configuration:" "Yellow" 
Output "Ensure that the maximum amount of memory allocated per shell for remote shell management is at least $recommendedMaxMemory MB." "Yellow"
[int]$originalMaxMemory = (Get-Item WSMan:\localhost\Shell\MaxMemoryPerShellMB).Value
if($originalMaxMemory -lt $recommendedMaxMemory)
{
    Set-Item WSMan:\localhost\Shell\MaxMemoryPerShellMB $recommendedMaxMemory
    $actualMaxMemory = (Get-Item WSMan:\localhost\Shell\MaxMemoryPerShellMB).Value
    Output "The maximum amount of memory allocated per shell for remote shell management is increased from $originalMaxMemory MB to $actualMaxMemory MB." "White"
}
else
{
    Output "The maximum amount of memory allocated per shell for remote shell management is $originalMaxMemory MB." "White"
}
#-----------------------------------------------------
# Get Second SharePoint server basic information
#-----------------------------------------------------
Output "The basic information of the second SharePoint server:" "White"

$domain             = $Env:USERDNSDOMAIN
Output "Domain name: $domain" "White"
$sut2ComputerName   = $ENV:ComputerName
Output "The name of the second SharePoint server: $sut2ComputerName" "White"
$userName           = $ENV:UserName
Output "The logon name of the current user: $userName " "White"

Output "Trying to get the SharePoint server version ..." "White"
$SharePointVersionInfo = GetSharePointVersion
$SharePointVersion = $SharePointVersionInfo[0]
if($SharePointVersion  -eq "Unknown Version")
{
    Write-Warning "Could not find supported SharePoint Server installation on the system! Install it first and then re-run this SUT configuration script. `r"
    Stop-Transcript
    exit 2
}
else
{
    OutPutSupportVersionInfo
}

[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint")

#----------------------------------------------------------------------------
# Start to configure SharePoint SUT to support HTTPS transport.
#----------------------------------------------------------------------------
Output "Configure the HTTPS service in the SharePoint site." "White"
Output "Steps for manual configuration:" "Yellow"
Output "1. Configure the SUT to support HTTPS." "Yellow"
Output "2. Set an alternate access mapping for HTTPS." "Yellow"
$webAppName = GetWebAPPName
AddHTTPSBinding "$sut2ComputerName" $SharePointVersion $webAppName

#----------------------------------------------------------------------------
# Add the user policy to enable the client side PowerShell scripts 
# to manage the SharePoint remotely.
#----------------------------------------------------------------------------
$webApplicationUrl = "http://$sut2ComputerName"
$uri = new-object System.Uri($webApplicationUrl)
$webApp = [Microsoft.SharePoint.Administration.SPWebApplication]::Lookup($uri)
$useClaims = $webApp.UseClaimsAuthentication
if($useClaims)
{
    Output "Steps for manual configuration:" "Yellow"
    Output "Add the user policy for $userName with the ""Full Control"" permission without name prefixed." "Yellow"
    AddUserPolicyWithoutNamePrefix $webApplicationUrl ($domain.split(".")[0] + "\" + $userName)
}

#-----------------------------------------------------
# Start to configure SUT for MS-COPYS.
#-----------------------------------------------------
Output "Begin to run the configuration process for MS-COPYS." "White"
Output "Steps for manual configuration:" "Yellow"
Output "The site collection named $MSCOPYSSiteCollectionName is currently being created; please wait ..." "Yellow"
$MSCOPYSSiteCollectionObject = CreateSiteCollection $MSCOPYSSiteCollectionName $sut2ComputerName "$domain\$userName" "$userName@$domain" $null $null

Output "Steps for manual configuration:" "Yellow"
Output "The subsite named $MSCOPYSSubSite with the meeting workspace template under the site collection $MSCOPYSSiteCollectionName is currently being created; please wait..." "Yellow"
$MSCOPYSSiteObject = CreateWeb $MSCOPYSSiteCollectionObject $false $MSCOPYSSubSite $MSCOPYSSubSite "MPS#0" $true

Output "Steps for manual configuration:" "Yellow"
Output "The document library $MSCOPYSSourceDocumentLibrary under the subsite $MSCOPYSSiteCollectionName is currently being created; please wait..." "Yellow"
CreateListItem $MSCOPYSSiteCollectionObject.RootWeb $MSCOPYSSourceDocumentLibrary 101

#Add field in list $MSCOPYSSourceDocumentLibrary
AddFieldInList $MSCOPYSSiteCollectionObject.RootWeb $MSCOPYSSourceDocumentLibrary $MSCOPYSTextFieldName 2 $false "" $MSCOPYSSourceLibraryFieldValue "false"
AddFieldInList $MSCOPYSSiteCollectionObject.RootWeb $MSCOPYSSourceDocumentLibrary $MSCOPYSWorkFlowEventFieldName 30

Output "Steps for manual configuration:" "Yellow"
Output "Uploading test data $MSCOPYSTestData to $MSCOPYSSourceDocumentLibrary under $MSSHDACCWSSiteCollectionName ..." "Yellow"
UploadFileToSharePointFolder $MSCOPYSSiteCollectionObject.RootWeb $MSCOPYSSourceDocumentLibrary $MSCOPYSTestData ".\$MSCOPYSTestData"  $True

$MSCOPYSSiteCollectionObject.Dispose()
$MSCOPYSSiteObject.Dispose()

#----------------------------------------------------------------------------
# Ending script
#----------------------------------------------------------------------------
Output "[SharePointSecondSUTConfiguration.PS1] has run successfully." "Green"
AddTimesStampsToLogFile "End" "$logFile"
Stop-Transcript
exit 0