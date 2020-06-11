###############################################################################
#
# Purpose: To Manage the softwares installed and output the create a Log File 
#          OutputLog.txt at the mentioned location
# 
# Author:  Anish Aggarwal
#
# Written on: 11th August, 2014 
#
###############################################################################


<#
.SYNOPSIS
Helps in Remotely running dos commands
.PARAMETER Server
Enter a ComputerName or IP Address
.PARAMETER command
Enter the dos command to be executed on the server
.PARAMETER LogFileLocation
Enter the log file location
.EXAMPLE
Run-RemoteCMD -Servers Server1 -command del *.*
#>
function Run-RemoteCMD { 
 
    param(    
    [Parameter(Mandatory=$true,
    valuefrompipeline=$true,
    ValueFromPipelineByPropertyName=$True,
    HelpMessage="Enter the dos command required")] 
    [string]$command,
     # Enter a ComputerName or IP Address
    [Parameter( 
    ValueFromPipeline=$True, 
    ValueFromPipelineByPropertyName=$True,
    Mandatory=$True,
    HelpMessage="Enter a ComputerName or IP Address")] 
    [String[]]$Server    
    ) 
    begin {        
        [string]$cmd = "CMD.EXE /C " +$command
                        } 
    process { 
        $newproc = Invoke-WmiMethod -class Win32_process -name Create -ArgumentList ($cmd) -ComputerName $server
        if ($newproc.ReturnValue -eq 0 ) 
                {
                    Write-Output " Command $($command) invoked Sucessfully on $($server)" 
                }
                # if command is sucessfully invoked it doesn't mean that it did what its supposed to do 
                #it means that the command only sucessfully ran on the cmd.exe of the server 
                #syntax errors can occur due to user input
    } 
    End{Write-Output "Script ...END"}
                 }



    # Start-Process -FilePath "$env:systemroot\system32\msiexec.exe" -ArgumentList "/i `"$msifile`" /qn /passive" -Wait -WorkingDirectory 
    # Install .NET 4.5 using MSIEXEC
    #Run-RemoteCMD -command "msiexec /i E:\CMRS_Automation\TestApp.msi /quiet /qn /norestart /log E:\CMRS_Automation\install.log PROPERTY1=value1 PROPERTY2=value2" -server "delvmpwlcmrs08"

    #msiexec /i E:\CMRS_Automation\TestApp.msi /quiet /qn /norestart /log E:\CMRS_Automation\install.log PROPERTY1=value1 PROPERTY2=value2
    

    #echo INSTALLATION SUCCESSFULLY COMPLETED >> .\install_log.txt
    #}
    
<#
.SYNOPSIS
Helps in Managing installed Software
.PARAMETER Servers
Enter a ComputerName or IP Address, accepts multiple ComputerNames
.PARAMETER Services
Enter the Service Names, accepts multiple Service Names
.PARAMETER Action
Enter the Action required like Start, Stop and Restart
.PARAMETER SetStartupType
Enter the SetStartupType required like Disable, Manual and Automatic
.PARAMETER LogFileLocation
Enter the log file location
.EXAMPLE
ManageWindowService -Servers Server1,Server2 -Services Service1, Service2 -Action Start, Stop, Restart
.EXAMPLE
ManageWindowService -Servers Server1,Server2 -Services Service1, Service2 -SetStartupType Automatic, Disable, Manual
.EXAMPLE
ManageWindowService -Servers Server1,Server2 -Services Service1, Service2 -SetStartupType Automatic, Disable, Manual -LogFileLocation <some location>
#>
function ManageInstalledSoftware{
    param(
# Enter the software to be installed
    [Parameter( 
    ValueFromPipeline=$True, 
    ValueFromPipelineByPropertyName=$True,
    HelpMessage="Enter the software to be installed")] 
    [String[]]$SoftwareName,    
     # Enter the status required to be checked
    [Parameter( 
    ValueFromPipeline=$True, 
    ValueFromPipelineByPropertyName=$True,
    #Mandatory=$True,
    HelpMessage="Enter the status required to be checked")] 
    [String[]]$Status,
     # Enter a ComputerName or IP Address, accepts multiple ComputerNames
    [Parameter( 
    ValueFromPipeline=$True, 
    ValueFromPipelineByPropertyName=$True,
    Mandatory=$True,
    HelpMessage="Enter a ComputerName or IP Address, accepts multiple ComputerNames")] 
    [String[]]$Servers  
    )
    Begin{
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
    Process{
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
            if($Status -eq "Install")
            {
                Run-RemoteCMD -command "msiexec /i E:\CMRS_Automation\TestApp.msi /quiet /qn /norestart /log E:\CMRS_Automation\Install.log PROPERTY1=value1 PROPERTY2=value2" -Server $server
            }
            if($Status -eq "Uninstall")
            {
                Run-RemoteCMD -command "msiexec /x E:\CMRS_Automation\TestApp.msi /quiet /qn /norestart /log E:\CMRS_Automation\Uninstall.log PROPERTY1=value1 PROPERTY2=value2" -Server $server
            }
            if($Status -eq "Check")
            {
                #CheckifSoftwareInstalled -SoftwareName $SoftwareName -Server $server
                CheckifSoftwareInstalled -SoftwareName $SoftwareName -Server $server | Tee-Object -filepath $strlogfilelocation
            }
        }
        
    }
    End{}
}

<#
.SYNOPSIS
Helps in Checking if a software is installed or not
.PARAMETER Server
Enter a ComputerName or IP Address
.PARAMETER Software Name
Enter the Software name that is needed to be checked like SQL Server. It will check for any software that has SQL Server mentioned in it
.EXAMPLE
CheckifSoftwareInstalled -Server Server1 -SoftwareName "SQL Server"
#>
Function CheckifSoftwareInstalled
{
param(
# Enter the software to be installed
    [Parameter( 
    ValueFromPipeline=$True, 
    ValueFromPipelineByPropertyName=$True,
    HelpMessage="Enter the software to be installed")] 
    [String[]]$SoftwareName,
    # Enter the Server
    [Parameter( 
    ValueFromPipeline=$True, 
    ValueFromPipelineByPropertyName=$True,
    HelpMessage="Enter the Server where the software needs to be checked")] 
    [String[]]$Server
    )
    Begin{}
    Process
    {
    

        #Define the variable to hold the location of Currently Installed Programs

        $UninstallKey="SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall" 

        #Create an instance of the Registry Object and open the HKLM base key

        $reg=[microsoft.win32.registrykey]::OpenRemoteBaseKey('LocalMachine',$Server) 

        #Drill down into the Uninstall key using the OpenSubKey Method

        $regkey=$reg.OpenSubKey($UninstallKey) 

        #Retrieve an array of string that contain all the subkey names

        $subkeys=$regkey.GetSubKeyNames() 

        #Open each Subkey and use GetValue Method to return the required values for each

        foreach($key in $subkeys){

            $thisKey=$UninstallKey+"\\"+$key 

            $thisSubKey=$reg.OpenSubKey($thisKey) 

            $obj = New-Object PSObject

            $obj | Add-Member -MemberType NoteProperty -Name "ComputerName" -Value $Server

            $obj | Add-Member -MemberType NoteProperty -Name "DisplayName" -Value $($thisSubKey.GetValue("DisplayName"))

            $obj | Add-Member -MemberType NoteProperty -Name "DisplayVersion" -Value $($thisSubKey.GetValue("DisplayVersion"))

            $obj | Add-Member -MemberType NoteProperty -Name "InstallLocation" -Value $($thisSubKey.GetValue("InstallLocation"))

            $obj | Add-Member -MemberType NoteProperty -Name "Publisher" -Value $($thisSubKey.GetValue("Publisher"))
            
            if($obj.DisplayName -like "*$SoftwareName*")
            {
                $flag=1
                Write-Output "Server already contains the Software"
                break
            }
        } 
        if(!$flag)
            {
                Write-Output "Server doesn't contain the Software"
                   
            }
    }
End{}
}