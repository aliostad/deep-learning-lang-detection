[cmdletbinding()]
param (
    [parameter(mandatory=$false)]
    [string]$Operator,

    [parameter(mandatory=$false)]
    [string]$MachineGroep,

    [parameter(mandatory=$false)]
    [string]$TDNumber,

    [parameter(mandatory=$true)]
    [string]$KworkingDir
)

#region StandardFramework
Set-Location $KworkingDir
    
. .\WriteLog.ps1
$Domain = $env:USERDOMAIN
$MachineName = $env:COMPUTERNAME
$Procname = $MyInvocation.MyCommand.Name
$Customer = $MachineGroep.Split('.')[2]

$logvar = New-Object -TypeName PSObject -Property @{
    'Domain' = $Domain 
    'MachineName' = $MachineName
    'procname' = $procname
    'Customer' = $Customer
    'Operator'= $Operator
    'TDNumber'= $TDNumber
}

Remove-Item "$KworkingDir\ProcedureLog.log" -Force -ErrorAction SilentlyContinue
f_New-Log -logvar $logvar -status 'Start' -LogDir $KworkingDir -Message "Title: `'$Kworking`' Script"
#endregion StandardFramework
    
#region Execution
  f_New-Log -logvar $logvar -status 'Info' -Message 'Loading the WSUS assembly' -LogDir $KworkingDir
  try
  {
    [reflection.assembly]::LoadWithPartialName("Microsoft.UpdateServices.Administration") | Out-Null
    $CleanUpScope = New-Object Microsoft.UpdateServices.Administration.CleanupScope
    f_New-Log -logvar $logvar -status 'Success' -Message 'Loaded the WSUS assembly' -LogDir $KworkingDir
  }
  catch
  {
    f_New-Log -logvar $logvar -status 'Error' -Message 'Unable to load the WSUS assembly' -LogDir $KworkingDir
    return
  }

  f_New-Log -logvar $logvar -status 'Info' -Message 'Cleaning computers not contacting the WSUS server' -LogDir $KworkingDir
  try
  {
    #Computers not contacting the server
    'Computers not contacting the server'
    $cleanUpScope.CleanupObsoleteComputers = $true
    $WSUSServer= [Microsoft.UpdateServices.Administration.AdminProxy]::GetUpdateServer()
    $cleanUpManager = $WSUSServer.GetCleanupManager()
    $CleanUpManager.PerformCleanup($cleanupScope)
    f_New-Log -logvar $logvar -status 'Success' -Message 'Cleaned computers not contacting the WSUS server' -LogDir $KworkingDir
  }
  catch
  {
    f_New-Log -logvar $logvar -status 'Error' -Message 'Unable to clean computers not contacting the WSUS server' -LogDir $KworkingDir
  }

  f_New-Log -logvar $logvar -status 'Info' -Message 'Cleaning expired updates' -LogDir $KworkingDir
  try
  {
    #Expired Updates
    'Expired Updates'
    $cleanUpScope.DeclineExpiredUpdates = $true
    $WSUSServer= [Microsoft.UpdateServices.Administration.AdminProxy]::GetUpdateServer()
    $cleanUpManager = $WSUSServer.GetCleanupManager()
    $CleanUpManager.PerformCleanup($cleanupScope)
    f_New-Log -logvar $logvar -status 'Success' -Message 'Cleaned expired updates' -LogDir $KworkingDir
  }
  catch
  {
    f_New-Log -logvar $logvar -status 'Error' -Message 'Unable to clean expired updates' -LogDir $KworkingDir
  }

  f_New-Log -logvar $logvar -status 'Info' -Message 'Cleaning unused updates and update revisions' -LogDir $KworkingDir
  try
  {
    #Unused Updates and Update Revisions
    'Unused Updates and Update Revisions'
    $CleanUpScope.CleanObsoleteUpdates = $true
    $WSUSServer= [Microsoft.UpdateServices.Administration.AdminProxy]::GetUpdateServer()
    $cleanUpManager = $WSUSServer.GetCleanupManager()
    $CleanUpManager.PerformCleanup($cleanupScope)
    f_New-Log -logvar $logvar -status 'Success' -Message 'Cleaned unused updates and update revisions' -LogDir $KworkingDir
  }
  catch
  {
    f_New-Log -logvar $logvar -status 'Error' -Message 'Unable to clean unused updates and update revisions' -LogDir $KworkingDir
  }

  f_New-Log -logvar $logvar -status 'Info' -Message 'Cleaning superseded updates' -LogDir $KworkingDir
  try
  {
    #Superseded Updates
    'Superseded Updates'
    $cleanUpScope.DeclineSupersededUpdates = $true
    $WSUSServer= [Microsoft.UpdateServices.Administration.AdminProxy]::GetUpdateServer()
    $cleanUpManager = $WSUSServer.GetCleanupManager()
    $CleanUpManager.PerformCleanup($cleanupScope)
    f_New-Log -logvar $logvar -status 'Success' -Message 'Cleaned superseded updates' -LogDir $KworkingDir
  }
  catch
  {
    f_New-Log -logvar $logvar -status 'Error' -Message 'Unable to clean superseded updates' -LogDir $KworkingDir
  }

  f_New-Log -logvar $logvar -status 'Info' -Message 'Cleaning unneeded update files' -LogDir $KworkingDir
  try
  {
    #Unneeded update files
    'Unneeded update files'
    $cleanUpScope.CleanupUnneededContentFiles = $true
    $WSUSServer= [Microsoft.UpdateServices.Administration.AdminProxy]::GetUpdateServer()
    $cleanUpManager = $WSUSServer.GetCleanupManager()
    $CleanUpManager.PerformCleanup($cleanupScope)
    f_New-Log -logvar $logvar -status 'Success' -Message 'Cleaned unneeded update files' -LogDir $KworkingDir
  }
  catch
  {
    f_New-Log -logvar $logvar -status 'Error' -Message 'Unable to clean unneeded update files' -LogDir $KworkingDir
  }
#endregion Execution
