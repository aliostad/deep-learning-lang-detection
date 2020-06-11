<#
 
.SYNOPSIS  
  The script helps to reinstall ADFS on an ADFS farm member Windows 2012 R2 ADFS
.DESCRIPTION
  Script can be used to remove or add farm member to ADFS, or reinstall as needed.
  Most commmon scenarios are addressed, the farm can either be SQL and Primary\Secondary.
  The service account be used either groupManaged account or part of SQL.
  Removal process includes restart and a scheudled task removing WID data from drive at a system startup
  DISCLAIMER
    THIS SAMPLE CODE AND ANY RELATED INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED,
    INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.  
    We grant You a nonexclusive, royalty-free right to use and modify the Sample Code and to reproduce and distribute the object
    code form of the Sample Code, provided that You agree: (i) to not use Our name, logo, or trademarks to market Your software
    product in which the Sample Code is embedded; (ii) to include a valid copyright notice on Your software product in which the
    Sample Code is embedded; and (iii) to indemnify, hold harmless, and defend Us and Our suppliers from and against any claims
    or lawsuits, including attorneys’ fees, that arise or result from the use or distribution of the Sample Code.
    Please note: None of the conditions outlined in the disclaimer above will supersede the terms and conditions contained within
    the Premier Customer Services Description.
  .PARAMETER -log 
   Gloabal script paremeter Path to cutsom log location. Default log loctaion is "C:\ProgramData"
  .PARAMETER DNSname
   Install-ADFS only parameter. DNS name of the ADFS farm and subject of certficate
  .PARAMETER serviceAccount
   Install-ADFS only parameter. Name of service account for ADFS service in form domain\username. Can accept groupManagedaccount or regular account.
  .PARAMETER ConfigSource
   Install-ADFS only parameter. Location of the ADFS configuration. Can be either name of the Primary ADFS server or SQL connect string
  .EXAMPLE
   ./manage-ADFSNode.ps -verbose
   Starts script with additional verbose information provided on screen.
   
#>

[CmdletBinding()]


param(
[string]$log
)

Function verify-serviceAccount ($username)
{
    

    $strFilter = "(&(ObjectClass=msDS-GroupManagedServiceAccount)(samAccountName=$($username.split("\")[1])))"
    $objDomain = New-Object System.DirectoryServices.DirectoryEntry
    $objSearcher = New-Object System.DirectoryServices.DirectorySearcher
    $objSearcher.SearchRoot = $objDomain
    $objSearcher.PageSize = 1000
    $objSearcher.Filter = $strFilter
    $objSearcher.SearchScope = "Subtree"
    $colProplist = "name"
    foreach ($i in $colPropList)
    {
        $objSearcher.PropertiesToLoad.Add($i)
    }
    $colResults = $objSearcher.FindAll()


    if ($colResults.Count -eq 0)
    {

        return $false
    }
    else
    {
        return $true
    }
}

Function Install-ADFS
{
    [CmdletBinding()]
    param(
    [Parameter(Mandatory=$true,HelpMessage="Please enter DNS name of the ADFS farm")]
    [string]$DNSname,
    [Parameter(Mandatory=$true,HelpMessage="Please type ADFS service account name in a form Domain\UserName")]
    [string]$serviceAccount,
    [Parameter(Mandatory=$true,HelpMessage = "Please type name of the primary ADFS server in the farm or SQL connection string")]
    [string]$ConfigSource
    )


$commandParams =@{}
write-log "Validtaing parameters"
$certThumprint = (dir Cert:\LocalMachine\My | ?{$_.subject -match $DNSname}).Thumbprint

write-log "Verifying installed certifciate subject"
if ($certThumprint -eq $null)
{
    write-log "Certficate for the ADFS farm $($DNSname) not found. Terminating script" -severity ERROR
    return
}
$commandParams.Add("CertificateThumbprint",$certThumprint)


write-log "Idetifying service account type"
$accountresult = (verify-serviceAccount $serviceAccount)
if ( $accountresult -eq $true)
{
    write-log "Account $($serviceAccount) by the type of groupManagedAccount found"
    $commandParams.Add("GroupServiceAccountIdentifier",$serviceAccount)
 
}
else
{
    write-log "Account $($serviceAccount) is a regular service account. Please enter password when prompted "
    $adfsServiceCredentials = Get-Credential $serviceAccount
    $commandParams.Add("ServiceAccountCredential",$serviceAccount)

}
write-log "Testing configuration data"
if (Test-Connection -ComputerName $ConfigSource -Quiet -Count 2)
{

    write-log "Primary ADFS server $($ConfigSource) found"
    $commandParams.Add("PrimaryComputerName",$ConfigSource)

}
else
{
    write-log "Following SQL connnection string will be used $($ConfigSource)"
    $commandParams.Add("SQLConnectionString",$ConfigSource)

}

$ADFSInstall = Get-WindowsFeature -name ADFS-Federation
if (!($ADFSInstall.InstallState -eq "Installed"))
{

    
    install-windowsfeature -name ADFS-Federation -IncludeManagementTools

}

write-log "Completed preliminary checks. Joining the farm $($DNSname)"
$addresult = Add-AdfsFarmNode @commandParams -ErrorAction Stop

if ( $addresult.Message -eq "Success")
{
    write-log "$($env:COMPUTERNAME) was successfully added to the ADFS Farm $($DNSname)"

}

}







Function Remove-ADFS
{
    
    
    
    $title = "Remove ADFS"
    $message = "You selected to remove ADFS. At the end of this process server will be rebooted. Are you sure you want to proceed?"

    $yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes"
    $no = New-Object System.Management.Automation.Host.ChoiceDescription "&No"

    $options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)

    $result = $host.ui.PromptForChoice($title, $message, $options, 0) 

    switch ($result)
    {
       
        1 {
            write-log "Operation canceled.Ending script" 
            return 
          }
    }

    write-log "Removing ADFS Server" 
    Uninstall-WindowsFeature -Name ADFS-Federation -ErrorAction Stop | Out-Null

    write-log "Removing Windows Internal Database service"  
    Uninstall-WindowsFeature -Name Windows-Internal-Database -ErrorAction Stop

    write-log "Creating scheudled task to remove Windows Internal Database files after reboot"  
    $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-command ""& {Remove-Item C:\Windows\WID\data -Recurse -Force;Start-Process -FilePath schtasks.exe -ArgumentList """"""/delete /TN CleanWID /F /HRESULT""""""}"" /RL HIGHEST"" "
    $trigger = New-ScheduledTaskTrigger -AtStartup
    $settings = New-ScheduledTaskSettingsSet -DisallowDemandStart
    Register-ScheduledTask  "CleanWID" -RunLevel Highest -User SYSTEM -Trigger $trigger -Action $action -Settings $settings -ErrorAction Stop

    write-log "Restarting computer in 10 seconds click Ctrl+C to stop"
    $i = 0
    Do 
    {
        Start-Sleep -Seconds 1
        $i++


    }while ($i -le 10) 
    Restart-Computer -Force



}

 
function write-log
{ 


param(
    [Parameter(ValueFromPipeline=$true,Mandatory=$true)]
    $message,
    [ValidateSet("ERROR","INFO","WARN")]
    $severity,
    $logfile

)




$WhatIfPreference=$false
$timeStamp = get-date -UFormat %Y%m%d-%I:%M:%S%p
switch ($severity)
 {

  "INFO" {$messageColor = "Green"}
  "ERROR" {$messageColor = "Red"}
  "WARN" {$messageColor = "Yellow"}
    
 }
 Write-Host "$($timeStamp) $($severity) $($message)" -ForegroundColor $messageColor
 if ($logfile.length -ge 0)
 {
    write-output "$($timeStamp) $($severity) $($message)" | Out-File -FilePath $logfile -Encoding ascii -Append
 }



}

$PSDefaultParameterValues = @{

"write-log:severity"="INFO";
"write-log:logfile"="$($env:ALLUSERSPROFILE)\$($MyInvocation.MyCommand.Name).log"
}


if ($log.Length -ne 0)
{
 if(Test-Path (split-path $log -parent))
 {
    $PSDefaultParameterValues["write-log:logfile"]=$log
    write-log "Setting location of log file to $($log)"

 }
 else
 {
    write-log "Custom log is not found setting log to $($env:ALLUSERSPROFILE)\$($MyInvocation.MyCommand.Name).log"
 }

}
trap{ write-log -message $_.Exception -severity "ERROR";break;}

[int]$action = Read-Host "Please select one of the following options`n1 - Remove ADFS server from the farm (Server will reboot!)`n2 - Add Server to the Farm`nYour selection" -ErrorAction Stop

 switch ($action)
 {

    1{Remove-ADFS}

    2{
        
        Install-ADFS
     }

 }


