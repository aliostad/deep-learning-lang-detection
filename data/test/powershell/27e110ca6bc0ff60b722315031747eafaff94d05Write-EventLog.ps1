<#
.SYNOPSIS 
    Writes a message to the event log. 

.DESCRIPTION
    This runbook writes a message to the event log. The message is written to the provided log name and to the 
    provided source name. If the source does not exists at the time of writing the message, the source is automatically created.


.PARAMETER AzureSubscriptionName
    Name of the Azure subscription to connect to.
    
.PARAMETER VMName    
    Name of the virtual machine to whom you want to assign static IP addess.  

.PARAMETER ServiceName
     Name of the Cloud Service that hosts and contains the Virtual machine
    
.PARAMETER AzureCredentials
    A credential containing an Org Id username / password with access to this Azure subscription.
    If invoking this runbook inline from within another runbook, pass a PSCredential for this parameter.

	If starting this runbook using Start-AzureAutomationRunbook, or via the Azure portal UI, pass as a string the
	name of an Azure Automation PSCredential asset instead. Azure Automation will automatically grab the asset with
	that name and pass it into the runbook.

.PARAMETER EventLogName
    The Name of the Windows Event Log i.e. Application/Security/System or custom where you want to log the message on a server.

.PARAMETER EventSourceName
    The Name of the Windows Event Source representing the source of message.

.PARAMETER Message
    The message that should be logged.

.PARAMETER MessageType
    Type of message includes Infomration, Error or Warning.

.PARAMETER EventNumber
    Any custom event number to denote type of message/event logged

	

.EXAMPLE
    Write-EventLog -AzureSubscriptionName "Visual Studio Ultimate with MSDN" -VMName "Sample VM Name" -ServiceName "CloudServiceName"  -AzureCredentials $cred -EventLogName "Application" -EventSourceName "Your source Name"  -Message "Message to be logged" -MessageType Information -EventNumber 1000

.NOTES
    AUTHOR:Ritesh Modi
    LASTEDIT: March 30, 2015 
    Blog: http://automationnext.wordpress.com
    email: callritz@hotmail.com
#>
workflow Write-EventLog
{
    param
    (
        [parameter(Mandatory=$true)]
        [String]
        $AzureSubscriptionName,
     
        [parameter(Mandatory=$true)]
        [String]
        $VMName,
        
        [parameter(Mandatory=$true)]
        [String]
        $ServiceName,

        [parameter(Mandatory=$true)]
        [String]
        $AzureCredentials,

        [parameter(Mandatory=$true)]
        [String]
        $EventLogName,

         [parameter(Mandatory=$true)]
        [String]
        $EventSourceName,

        [parameter(Mandatory=$true)]
        [String]
        $Message,

         [parameter(Mandatory=$true)]
        [String]
        $MessageType,

         [parameter(Mandatory=$true)]
        [String]
        $EventNumber
    )
    
    # Get the credential to use for Authentication to Azure and Azure Subscription Name 
    $Cred = Get-AutomationPSCredential -Name $AzureCredentials 

   # get the username and password from credential object  
   $CredUsername = $Cred.UserName
   $CredPassword = $Cred.GetNetworkCredential().Password

    # Select an appropriate organization ID for connecting to Azure 
    $AzureAccount = Add-AzureAccount -Credential $Cred 

    # Connect to Azure and Select Azure Subscription 
    $AzureSubscription = Select-AzureSubscription -SubscriptionName $AzureSubscriptionName 

    # invoking Connect-AzureVM runbook for installing the management certificate to be used for authentication
    Connect-AzureVM -AzureSubscriptionName $AzureSubscriptionName -ServiceName $ServiceName -VMName $VMName

    # obtaining the uri of remove virtual machine winrm
    $uri = Get-AzureWinRMUri -ServiceName $ServiceName -Name $VMName 

     # Inline script for installation of windows feature on Virtual machine
    $OutputMessage = inlinescript {
          
          # the OutputMessage variable will be used for returning the message to the user
          $OutputMessage = ""
          
           try{ # start of try block
                     $subscriptionPass = $using:CredPassword
                     $subscriptionUser = $using:CredUsername
                     $password = Convertto-SecureString -String $subscriptionPass -AsPlainText -Force

                     # creating credential object used for remoting to the virtual machine
                     $cred = New-Object System.Management.Automation.PSCredential $subscriptionUser, $password   
                    
                    # invoking the remote command on target virtual machine with custom script block
                     $OutputMessage =   Invoke-Command -ConnectionUri $using:uri -credential $cred `
                                            -ArgumentList $using:EventLogName, $using:EventSourceName, $using:EventNumber, $using:Message, $using:MessageType,  $using:FeatureName, $using:VMName, $using:ServiceName -ScriptBlock {
                        param ($EventLogName, $EventSourceName, $EventNumber, $Message, $MessageType ,$FeatureName, $VMName, $ServiceName)

                      try {
                                # check if the source name exists. If not create a new event source based on provided source name
                                if(![System.Diagnostics.EventLog]::SourceExists($EventSourceName)){
                                    [System.Diagnostics.EventLog]::CreateEventSource($EventSourceName , $EventLogName)
                                    $OutputMessage +="A new Event source with the name $EventSourceName created successfully within Log $EventLogName  !! `r`n"  
                                }


                                # log the message
                                    $LogMessage = New-Object System.Diagnostics.EventLog
                                    $LogMessage.Log = $EventLogName
                                    $LogMessage.Source = $EventSourceName
                                    $LogMessage.WriteEntry($Message, $MessageType, $EventNumber)
                                    $OutputMessage +="Message $Message was written to EventLog $EventLogName, source $EventSourceName on Virtual Machine $VMName in Cloud Service $ServiceName successfully !! `r`n"  

                                
                                
                     } catch {
                            $OutputMessage +="Error writing message  to EventLog $EventLogName, source $EventSourceName on Virtual Machine $using:VMName in Cloud Service $using:ServiceName  !! `r`n"
                     }   
                    
                    return $OutputMessage        
                 } # end of invoke-command scriptblock  
                   
            } catch {
                $OutputMessage +="Error remoting to Virtual Machine $using:VMName in Cloud Service $using:ServiceName  !! `r`n"
            }   
         return $OutputMessage
    }
          $OutputMessage # final output of the entire installation operation
}




    
