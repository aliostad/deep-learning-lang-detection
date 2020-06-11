###############################################################################
#
# Purpose: To check the .NET FW installed and output the defaulted servers to
#          a Log File DefaultedServers.txt
# 
# Author:  Anish Aggarwal
#
# Written on: 14th July, 2014 
#
# Input parameters - $frameWorktobeChecked - .NET FW Version which needs to be 
# checked
#
#
###############################################################################

Import-Module -Name "..\ManageWindowService\Services.psm1" -DisableNameChecking
Import-Module -Name ".\EnableExecutionofRemoteCommands.psm1" -DisableNameChecking
Import-Module -Name ".\Functions.psm1" -DisableNameChecking

<#
.SYNOPSIS
Helps in getting info of .NET FW Version installed
.PARAMETER Servers
Enter a ComputerName or IP Address, accepts multiple ComputerNames
.PARAMETER Operation
Enter the Operation required like List All FWs, Specific. If it's not specified, the default parameter is ListAllFWs
.PARAMETER LogFileLocation
Enter the log file location
.PARAMETER frameWorktobeChecked
Enter the .NET FW to be checked
.EXAMPLE
ManageWindowService -Servers Server1,Server2 -Operation "Specific" -frameWorktobeChecked <FW like 4.0,4.5,4.5.1,4.5.2,3.5, etc>
.EXAMPLE
ManageWindowService -Servers Server1,Server2 -Operation "ListAllFWs"
.EXAMPLE
ManageWindowService -Servers Server1,Server2 -LogFileLocation <some location>
#>
function GetFrameworkVersion
{
[CmdletBinding()]
param(
        [Parameter( 
        ValueFromPipeline=$True, 
        ValueFromPipelineByPropertyName=$True,        
        HelpMessage="Enter the framework to be checked")] 
        [string]$frameWorktobeChecked,
        # Enter a ComputerName or IP Address, accepts multiple ComputerNames
        [Parameter( 
        ValueFromPipeline=$True, 
        ValueFromPipelineByPropertyName=$True,
        Mandatory=$True,
        HelpMessage="Enter a ComputerName or IP Address, accepts multiple ComputerNames")] 
        [String[]]$Servers,        
        #Enter the Operation Required
        [Parameter(
        ValueFromPipeline=$True, 
        ValueFromPipelineByPropertyName=$True,
        HelpMessage="Enter the Operation Required")] 
        [String[]]$Operation,
        #Enter the log file location
        [Parameter( 
        ValueFromPipeline=$True, 
        ValueFromPipelineByPropertyName=$True,
        HelpMessage="Enter the log file location")] 
        [String[]]$LogFileLocation
)
Begin 
{
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
}
Process 
{
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

    #if($requestedServer)
    #{
    #   $servers=$requestedServer                        #assigns the server list to the single requested server
    #}
    #else
    #{
    #   $servers= Get-Content ".\ServerNames.txt"      
    #}


    Write-Output "Script is running from $baseserver"

    foreach($server in $ListofServers)
    {
        if(!$Operation)
        {
            $Operation="ListAllFWs"
        }
        EnableExecutionofRemoteCommands -Server $server	
        if($Operation -eq "Specific")
        {  	
            #GetInfoonFrameworkVersion -Server $server -frameworkVersionRequired $frameWorktobeChecked 
            GetInfoonFrameworkVersion -Server $server -frameworkVersionRequired $frameWorktobeChecked | Tee-Object -filepath $strlogfilelocation                #otuput both on the console and in the log file
        }
        if($Operation -eq "ListAllFWs")
        {
            Run-RemoteCMD -command "dir %WINDIR%\Microsoft.Net\Framework\v* /O:-N /B > E:\CMRS_Automation\result.txt" -compname $server | Tee-Object -path $strlogfilelocation                #otuput both on the console and in the log file
            Start-Sleep -Seconds 3
            #Get-Content \\$server\E$\CMRS_Automation\result.txt
            Get-Content \\$server\E$\CMRS_Automation\result.txt | Tee-Object -filepath $strlogfilelocation
            
            Remove-Item "\\$server\E$\CMRS_Automation\result.txt" –erroraction silentlycontinue
        }
        
        Write-Output " ---------------------- " 
        
        $serviceInfo = get-service -ComputerName $server -Name "WinRM" >> $strlogfilelocation
    	if ($serviceInfo.Status -eq "Running")  
    	{
    		StopService -computer $server -service "WinRM" -Verbose >> $strlogfilelocation          #Make it as ExecuteRemoteCommands -enable or -disable
    	}
    }
}
End {}
}