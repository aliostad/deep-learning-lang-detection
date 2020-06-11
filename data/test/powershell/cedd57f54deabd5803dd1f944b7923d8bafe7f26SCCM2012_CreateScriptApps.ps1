$PSDefaultParameterValues =@{"get-cimclass:namespace"="Root\SMS\site_DEX";"get-cimclass:computername"="DexSCCM";"get-cimInstance:computername"="DexSCCM";"get-ciminstance:namespace"="Root\SMS\site_DEX"}

#import the ConfigMgr Module
Import-Module -Name "$(split-path $Env:SMS_ADMIN_UI_PATH)\ConfigurationManager.psd1"

#set the location to the CMSite
Set-Location -Path DEX:


#region Create Script App & Deploy it
$Applicationname = "PowerShell Set PageFile"
#create a new Application
New-CMApplication -Name "$ApplicationName" -Description "The Script will set the  Page File Size to Initial 1024 and 2048 maximum" -SoftwareVersion "1.0" -AutoInstall $true 

#create a New Application Category
#New-CMCategory -CategoryType AppCategories -Name "PowerShell_Scripts" -Verbose

#Add-CMDeploymentType -ApplicationName <String> -DeploymentTypeName <String> -DetectDeploymentTypeByCustomScript -InstallationProgram <String> 
#-ManualSpecifyDeploymentType -ScriptContent <String> -ScriptInstaller -ScriptType <ScriptLanguage> [-AdministratorComment <String> ] 
#[-AllowClientsToShareContentOnSameSubnet <Boolean> ] [-ContentLocation <String> ] [-EstimatedInstallationTimeMinutes <Int32> ] 
#[-InstallationBehaviorType <InstallationBehaviorType> {InstallForSystem | InstallForSystemIfResourceIsDeviceOtherwiseInstallForUser | InstallForUser} ] 
#[-InstallationProgramVisibility <UserInteractionMode> {Normal | Minimized | Maximized | Hidden} ] [-InstallationStartIn <String> ] [-Language <String[]> ] 
#[-LogonRequirementType <LogonRequirementType> {OnlyWhenNoUserLoggedOn | OnlyWhenUserLoggedOn | WhereOrNotUserLoggedOn | WhetherOrNotUserLoggedOn} ] 
#[-MaximumAllowedRunTimeMinutes <Int32> ] [-PersistContentInClientCache <Boolean> ] [-RequiresUserInteraction <Boolean> ] [-RunInstallationProgramAs32BitProcessOn64BitClient <Boolean> ]
# [-RunScriptAs32bitProcessOn64bitClient <Boolean> ] [-UninstallProgram <String> ] [-UninstallStartIn <String> ] [-Confirm] [-WhatIf] [ <CommonParameters>]

$scriptDetection = @'
$pagefile = Get-WmiObject -Class Win32_PageFileSetting
$AutomaticManagePageFile = Get-WmiObject -Class Win32_ComputerSystem 
if (($pagefile.InitialSize -eq 1024) -and ($pagefile.MaximumSize -eq 2048) -and ($AutomaticManagePageFile.AutomaticManagedPagefile -eq $false))
{
    Write-host "Installed"
}
else
{

}
'@
#Add the Deployment type
$DeploymentTypeHash = @{
                    ManualSpecifyDeploymentType = $true #Yes we are going to manually specify the Deployment type
                    Applicationname = "$ApplicationName" #Application Name 
                    DeploymentTypeName = "POSH Set PageFile"    #Name given to the Deployment Type
                    DetectDeploymentTypeByCustomScript = $true # Yes deployment type will use a custom script to detect the presence of this deployment type
                    ScriptInstaller = $true # Indicates that the deployment type uses a script to detect the presence of this deployment type
                    ScriptType = 'PowerShell' # yep we will use PowerShell Script
                    ScriptContent =$scriptDetection  # Use the earlier defined here string
                    AdministratorComment = "This will set and reset the VM(pagefile) size" 
                    ContentLocation = "\\dexsccm\Packages\PS1_SetVMSize"  # NAL path to the package
                    InstallationProgram ='powershell.exe -file ".\Set_VM_Size.ps1"'  #Command line to Run for install
                    UninstallProgram ='powershell.exe -file ".\Unset_VM_size.ps1"'  #Command line to Run for un-Install
                    RequiresUserInteraction = $false  #Don't let User interact with this
                    InstallationBehaviorType = 'InstallForSystem' # Targeting Devices here
                    InstallationProgramVisibility = 'Hidden'  # Hide the PowerShell Console
                    }
#Add-CMDeploymentType -ApplicationName "$ApplicationName"  -DetectDeploymentTypeByCustomScript -ScriptType PowerShell -ScriptContent $scriptDetection -DeploymentTypeName "POSH Set PageFile"  -AdministratorComment "This will set and reset the VM(pagefile) size" -ContentLocation "\\dexsccm\Packages\PS1_SetVMSize" -InstallationProgram 'powershell.exe -file ".\Set_VM_Size.ps1"' -UninstallProgram 'powershell.exe -file ".\Unset_VM_size.ps1"' -RequiresUserInteraction $false -InstallationBehaviorType InstallForSystem -InstallationProgramVisibility Hidden
Add-CMDeploymentType @DeploymentTypeHash .

#Move the Applcation under the "PowerShell" folder

$Application  = Get-CMApplication -Name $Applicationname 
$POSHFolder = Get-CimInstance -ClassName "SMS_ObjectContainerNode" -Filter "Name='PowerShell'" -ComputerName DexSCCM -Namespace root/SMS/Site_DEX -Verbose

Invoke-CimMethod -ClassName SMS_ObjectContainerItem -MethodName MoveMembersEx -Arguments @{InstanceKeys=[string[]]$Application.ModelName;ContainerNodeID=[System.UInt32]0;TargetContainerNodeID=[System.UInt32]($POSHFolder.ContainerNodeID);ObjectTypeName="SMS_ApplicationLatest"} -Namespace root/sms/site_DEX -ComputerName DexSCCM -Verbose

#Distribute the Content
Start-CMContentDistribution -ApplicationName "$ApplicationName" -DistributionPointGroupName "Dex LAB DP group" -Verbose

#create a new Device Collection
New-CMDeviceCollection -Name "$ApplicationName" -Comment "All the Machines where $ApplicationName is sent to" -LimitingCollectionName "All Systems"  -RefreshType Periodic -RefreshSchedule (New-CMSchedule -Start (get-date) -RecurInterval Days -RecurCount 7) 

#Invoke Application Evaluation LifeCycle on the Machine 
Invoke-CimMethod -ClassName SMS_Client -MethodName TriggerSchedule -Arguments @{sScheduleID='{00000000-0000-0000-0000-000000000121}'}  -Namespace root/ccm

#region add the extra exit codes 21

$application = [wmi](Get-WmiObject -Query "select * from sms_application where LocalizedDisplayName='$ApplicationName' AND ISLatest='true'").__PATH

$Application = Get-CimInstance -ClassName "SMS_Application" -Filter "LocalizedDisplayName='$ApplicationName'"
$apptest1 = Get-WmiObject -Class SMS_Application -Filter "LocalizedDisplayName='$ApplicationName'"
#load the DLL
Add-Type -Path "$(Split-Path  $Env:SMS_ADMIN_UI_PATH)\Microsoft.ConfigurationManagement.ApplicationManagement.dll"

#Deserialize the SDMPackageXML
$Deserializedstuff = [Microsoft.ConfigurationManagement.ApplicationManagement.Serialization.SccmSerializer]::DeserializeFromString($application.SDMPackageXML)


#set the Error Codes 
$test = New-Object -TypeName Microsoft.ConfigurationManagement.ApplicationManagement.ExitCode
$test.Code = 20
#$test.Class = [Microsoft.ConfigurationManagement.ApplicationManagement.ExitCodeClass]"Failure" #Default is failure
$test.Name = "Setting VM Size failed"
$test.Code = 21

$test1 = New-Object -TypeName Microsoft.ConfigurationManagement.ApplicationManagement.ExitCode
$test1.Code = 22
#$test2.Class = [Microsoft.ConfigurationManagement.ApplicationManagement.ExitCodeClass]"Failure"
$test1.Name = "Resetting the VM Size to System managed Failed"

$Deserializedstuff.DeploymentTypes.Installer.ExitCodes.add($test)

$Deserializedstuff.DeploymentTypes.Installer.ExitCodes.add($test1)

$newappxml = [Microsoft.ConfigurationManagement.ApplicationManagement.Serialization.SccmSerializer]::Serialize($Deserializedstuff, $false)

#Set-CimInstance -InputObject $application -Property @{SDMPackageXML=$newappxml} -Verbose

$application.SDMPackageXML = $newappxml
$application.Put()

#endregion add the extra exit codes 21



#Distribute the Content to the DP Group
Start-CMContentDistribution -ApplicationName "$ApplicationName" -DistributionPointGroupName "Dex LAB DP group" -Verbose

#create the Device Collection
New-CMDeviceCollection -Name "$ApplicationName" -Comment "All the Machines where $ApplicationName is sent to" -LimitingCollectionName "All Systems"  -RefreshType Periodic -RefreshSchedule (New-CMSchedule -Start (get-date) -RecurInterval Days -RecurCount 7) 

#Add the Direct Membership Rule to add a Resource as a member to the Collection
Add-CMDeviceCollectionDirectMembershipRule -CollectionName "$ApplicationName"  -Resource (Get-CMDevice -Name "DexterDC") -Verbose

#start the Deployment
Start-CMApplicationDeployment -CollectionName "$ApplicationName" -Name "$ApplicationName" -DeployAction Install -DeployPurpose Available -UserNotification DisplayAll -AvaliableDate (get-date) -AvaliableTime (get-date) -TimeBaseOn LocalTime  -Verbose

#Run the Deployment Summarization
Invoke-CMDeploymentSummarization -CollectionName "$ApplicationName" -Verbose

Invoke-CMClientNotification -DeviceCollectionName "$ApplicationName" -NotificationType RequestMachinePolicyNow -Verbose

#endregion Create Basic App & Deploy it