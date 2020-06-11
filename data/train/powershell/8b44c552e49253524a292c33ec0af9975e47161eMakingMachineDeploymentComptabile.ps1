Param($Servers,$Drive)
Import-Module .\ManageInstalledSoftware.psm1 -disablenamechecking

if($Servers -match "\:\\")
{
    $ListofServers= Get-Content -Path $Servers                        # Get the contents of the servers stored in Servernames text file
}
else 
{
    $ListofServers=$Servers                        #assigns the server list to the single requested server
}
$strlogfilelocation= $LogFileLocation + "\OutputLog.txt"
if(Test-Path $strlogfilelocation)                         #if the logfile exist remove it
{
    Remove-Item $strlogfilelocation –erroraction silentlycontinue
} 

if($LogFileLocation)
{
    $strlogfilelocation= $LogFileLocation + "\OutputLog.txt"        #create text file to store the contents of defaulted servers
}
else
{
    $strlogfilelocation ="OutputLog.txt"        #create text file to store the contents of defaulted servers
}

# Initialize log files
Write-Output "" > $strlogfilelocation

$baseserver= hostname                        # store the name of the host/server where script is executed from
 
foreach($server in $ListofServers)
{
    Run-RemoteCMD -command "msiexec /i $Drive\CMRS_Automation\Deployment\BizTalkFactory PowerShell Provider 1.2.0.4.msi /quiet /qn /norestart /log D:\CMRS_Automation\InstallBTpsprovider.log PROPERTY1=value1 PROPERTY2=value2" -Server $server
    Run-RemoteCMD -command "msiexec /i $Drive\CMRS_Automation\Deployment\MSBuildCommunityTasks\MSBuild.Community.Tasks.v1.4.0.42.msi /quiet /qn /norestart /log D:\CMRS_Automation\MSBuildCommunityTasks.log PROPERTY1=value1 PROPERTY2=value2" -Server $server
    Run-RemoteCMD -command "msiexec /i $Drive\CMRS_Automation\Deployment\MSBuild Extension Pack April 2013\MSBuild Extension Pack 4.0.7.0 Installers\MSBuild Extension Pack 4.0.msi /quiet /qn /norestart /log D:\CMRS_Automation\MSBuildExtensionPack.log PROPERTY1=value1 PROPERTY2=value2" -Server $server
    Run-RemoteCMD -command "robocopy `"C:\Program Files (x86)\MSBuild`" `"C:\Program Files\MSBuild`"  /E /XN" -Server $server
}