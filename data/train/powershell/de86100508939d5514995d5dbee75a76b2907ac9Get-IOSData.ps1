#=============================================================================# 
#                                                                             # 
# Get-IOSData.ps1                           		                          # 
# Powershell Script automate SSH sessions to IOS Network Devices.	          # 
# Author: James Kowalczik                                                     # 
# Creation Date: 07.20.2016                                                   # 
# Modified Date: 07.20.2016                                                   # 
# Version: 1.0.0                                                              # 
#                                                                             # 
#=============================================================================# 
[CmdletBinding()]
Param(
   [String]$SSHHostname = "1.1.1.1",
   [String]$SSHUsername = "netuser",
   [String]$SSHPassword = "netpassword",
   [String]$Command = "show run",
   [Bool]$SaveOutputToFile = $false,
   [Bool]$SendEmail = $false,
   [String]$OutputResultsFile = "output.csv",
   [String[]]$EmailTo = @("user@domain.com"),
   [String]$EmailFrom = "Report@domain.com",
   [String]$EmailSubject = "Report",
   [String]$EmailServer = "mail.domain.com",
   [Bool]$DebugScript = $false
)

### Fun with Powershell ###
# . .\Get-IOSData.ps1
# $switches="1.1.1.1","1.1.1.2"
# $switches | % { $SSHHostname = $_; Show-Environment; Show-RunningConfig; }
###

############ HELPERS ##################
Try{
   $CiscoScriptPath = [System.IO.Path]::GetDirectoryName($myInvocation.MyCommand.Definition)
   $PreReqModuleFile = "$CiscoScriptPath\Modules\SSH-Sessions\SSH-Sessions.psd1"
   Import-Module SSH-Sessions -ErrorAction Stop
}Catch{
   Try{
      Import-Module $PreReqModuleFile -ErrorAction Stop
   }Catch{
      Write-Host $_.Exception.Message
      Write-Host $_.Exception.ItemName
      Write-Host "The module can be downloaded from: http://www.powershelladmin.com/w/images/a/a5/SSH-SessionsPSv3.zip"
      Write-Host "Make sure to unblock the SSH-SessionsPSv3.zip and then uncompress it's contents to a valid Module Path or specify the module file with the PreReqModuleFile command line option."
      Exit 1
   }
}
#####################################

## Just make this a module some day..
$ScriptName = $PSCommandPath
Function Show-Environment(){
   ## For dubugging purposes, output all varibales to the screen.
   Try{
      #$CommandName = $PSCmdlet.MyInvocation.InvocationName
      $CommandName = "$ScriptName"
      # Get the list of parameters for the command
      $ParameterList = (Get-Command -Name $CommandName).Parameters;

      # Grab each parameter value, using Get-Variable
      foreach ($Parameter in $ParameterList) {
         Get-Variable -Name $Parameter.Values.Name -ErrorAction SilentlyContinue | ft Name,Value -AutoSize
      }
   }Catch{
      Write-Host $_.Exception.Message
      Write-Host $_.Exception.ItemName
   }
}

Function RunSSHCommand($aCommand){
   If($DebugScript){ $QuietIt = @{Quiet = $false}}Else{ $QuietIt = @{Quiet = $true}}

   New-SshSession -ComputerName $SSHHostname -Username $SSHUsername -Password $SSHPassword | out-null
   $Results = Invoke-SshCommand -InvokeOnAll -Command $aCommand @QuietIt

   Return $Results
}

###########################
###########################
Function Show-RunningConfig(){
   $Command = "show run"
   $Results = RunSSHCommand $Command
   Return $Results
}

Function Show-StartupConfig(){
   Return RunSSHCommand "show start"
}

Function Get-InfoToMapNetwork(){
   #$(RunSSHCommand "show cdp neighbors detail")
   Get-CDPDetail
   $ConnectedInterfaces = $(RunSSHCommand "show int status | inc connected")
   $ConnectedInterfaces
   $ConnectedInterfaces = $ConnectedInterfaces.Split("`n")
   $ConnectedInterfaces | % { 
                               $aInt = $_.Split(" ")[0] 
                               $(RunSSHCommand "show run int $aInt")
                            }
}

Function New-CDPNeighbor(){
   Param($Name, $IPAddress, $Interface)
   
   $aCDPNeighbor = New-Object PSObject | Select-Object Name,IPAddress,Interface
  
   $aCDPNeighbor.Name = $Name
   $aCDPNeighbor.IPAddress = $IPAddress
   $aCDPNeighbor.Interface = $Interface
  
   Return $aCDPNeighbor
}

Function Get-CDPDetail(){
   $cdpdetail = RunSSHCommand "show cdp neighbors detail"
   $cdpdetail = $cdpdetail.Split("`n")
   $CDPNeighbors = @()
   $cdpdetail | % { 
                     If($_ -match "^Device Id"){ 
                        $CDPNeighbor = New-CDPNeighbor
                        $CDPNeighbor.Name = $_.Split(" ")[2] 
                     } 
                     If($CDPNeighbor.Name -And $_ -match "IP address"){ 
                        $CDPNeighbor.IPAddress = $_.Split(" ")[4]
                     }
                     If($CDPNeighbor.Name -And $_ -match "^Interface:"){ 
                        $CDPNeighbor.Interface = $_
                     }
                     If($CDPNeighbor.Name -And $CDPNeighbor.Interface -And $CDPNeighbor.IPAddress){
                        $CDPNeighbors += $CDPNeighbor
                        $CDPNeighbor = $null
                     }
                  }
   Return $CDPNeighbors | fl
}

## This function which creates a custom object is needed for the NormalizeData function below..
Function New-SwitchPort(){
   Param($Name, $Description, $Type, $Vlan, $NativeVlan, $SpanningTree, $Shutdown, $isConnected)
   
   $aSwitchPort = New-Object PSObject | Select-Object Name,Description,Type,Vlan,NativeVlan,SpanningTree,Shutdown,isConnected

   $aSwitchPort.Name = $Name
   $aSwitchPort.Description = $Description
   $aSwitchPort.Type = $Type
   $aSwitchPort.Vlan = $Vlan
   $aSwitchPort.NativeVlan = $NativeVlan
   $aSwitchPort.SpanningTree = $SpanningTree
   $aSwitchPort.Shutdown = $Shutdown
   $aSwitchPort.isConnected = $isConnected
  
   Return $aSwitchPort 
}

Function NormalizeData(){
   If($DebugScript){ $QuietIt = @{Quiet = $false}}Else{ $QuietIt = @{Quiet = $true}}

   $Command = "show run"
   New-SshSession -ComputerName $SSHHostname -Username $SSHUsername -Password $SSHPassword | out-null
   $Results = Invoke-SshCommand -InvokeOnAll -Command $Command @QuietIt

   $SwitchPorts = @()
   $Result = $Results.Split("`n")
   $int = 0
   ForEach($aLine in $Result){
      If($aLine -match "^interface"){
         $int = 1
         $aName = $aLine.Split(" ")[1]
         $SwitchPort = New-SwitchPort  
         $SwitchPort.Name = $aName
         $SwitchPort.NativeVlan = 1
         $SwitchPort.Vlan = 1
         $SwitchPort.Shutdown = $false
         $SwitchPort.SpanningTree = ""
      }
      If($aLine -match " description" -And $int -eq 1){
         $aDescription = $aLine -Split " description " | Out-String
         $aDescription = $aDescription.Trim()
         $SwitchPort.Description = $aDescription
      }
      If($aLine -match " spanning-tree" -And $int -eq 1){
         $aSpanningTree = $aLine -Split " spanning-tree " | Out-String
         $aSpanningTree = $aSpanningTree.Trim()
         $SwitchPort.SpanningTree = $aSpanningTree
      }
      If($aLine -match " shutdown" -And $int -eq 1){
         $SwitchPort.Shutdown = $true
      }
      If($aLine -match " switchport trunk native vlan" -And $int -eq 1){
         $aNativeVlan = $aLine.Split(" ")[5]
         $SwitchPort.NativeVlan = $aNativeVlan
      }
      If($aLine -match " switchport mode" -And $int -eq 1){
         $aType = $aLine.Split(" ")[3]
         $SwitchPort.Type = $aType
      }
      If($aLine -match " switchport trunk allowed vlan" -And $int -eq 1){
         $aVlan = $aLine.Split(" ")[5]
         $SwitchPort.Vlan = $aVlan
      }  
      If($aLine -match " switchport access vlan" -And $int -eq 1){
         $aVlan = $aLine.Split(" ")[4]
         $SwitchPort.Vlan = $aVlan
      }
      if($aLine -match "^!" -And $int -eq 1){
         If($int -eq 1){ $int = 0 }
         $SwitchPorts += $SwitchPort
      }
   }
   
   $SwitchPorts; Return
   $SwitchPorts | % {
                    $intName = $_.Name
                    $Command = "show int $intName"
                    New-SshSession -ComputerName $SSHHostname -Username $SSHUsername -Password $SSHPassword | out-null
                    $Results = Invoke-SshCommand -InvokeOnAll -Command $Command @QuietIt
                    $Result = $Results.Split("`n")
                    ForEach($aLine in $Result){
                       Write-Host $aLine
                       If($aLine -match "^$intName is up"){
                          Write-Host "$intName is up"
                       }
                    }
                 }
}