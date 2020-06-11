
# Array contains the queues to be created.
$Queues2Create = @( "disample/reademails.svc","disample/crushmails.svc","disample/updatecontents.svc")
# BasePath for the queue to be created
$QueueBasePath = "dicore/Processor/"
# List of users who need access to the private queue 
$UserAccess = @("\NetworkService", "\ANONYMOUS LOGON", "diad\mani") 
# Not Yet Implemented in this version of Script
$AccessTypes = @("ReceiveMessage","PeekMessage","WriteMessage")

Function MessageQueuingConfiguration
 {
    <#
        .SYNOPSIS
        .DESCRIPTION     : Create Private Messaging queue.
        .PARAMETER
        .EXAMPLE
        .NOTES
            FunctionName : MessageQueuingConfiguration
            Created by   : Manimaran Chandrasekaran
    #>
 [CmdletBinding()]
 Param
     (
     [array]$Queues2Create,
     [array]$UserAccess, 
     [String]$QueueBasePath
     )
 Begin
 {
        # Create the Queue Object
		[Reflection.Assembly]::LoadWithPartialName( "System.Messaging" )
		$messagingQueue = [System.Messaging.MessageQueue]
     }
 Process
 {
 	try
	{
		# Current username the script is running under
		$currentusername = [Security.Principal.WindowsIdentity]::GetCurrent().Name
		foreach($Q in $Queues2Create){ 
				$label = "private$\" + $QueueBasePath + $Q
		        $msmq = ".\private$\" + $QueueBasePath + $Q
		        if($messagingQueue::Exists($msmq)){
		            Write-Verbose ("    " + $msmq + "This queue already exists, we will recreate for you")
		            $messagingQueue::Delete($msmq)
		        }
		        $queueInstance = $messagingQueue::Create( $msmq , 1)
				$queueInstance.Label = $label
				
                # Providing user access
                $queueInstance.SetPermissions($currentusername, [System.Messaging.MessageQueueAccessRights]::FullControl, [System.Messaging.AccessControlEntryType]::Set)
				foreach($username in $UserAccess){
			 		$queueInstance.SetPermissions($username, [System.Messaging.MessageQueueAccessRights]::ReceiveMessage, [System.Messaging.AccessControlEntryType]::Set)
			  		$queueInstance.SetPermissions($username, [System.Messaging.MessageQueueAccessRights]::PeekMessage, [System.Messaging.AccessControlEntryType]::Allow)
			  		$queueInstance.SetPermissions($username, [System.Messaging.MessageQueueAccessRights]::WriteMessage, [System.Messaging.AccessControlEntryType]::Allow)
				}
		    }
		# List all queues available on the server
        Write-Host ("Below are the list of queue currently available")
		foreach($q in $messagingQueue::GetPrivateQueuesByMachine("."))
		{  
		    Write-Host ("    " + $q.QueueName)
		}
	}
	catch
	{
		$ErrorMessage = $_.Exception.Message
		Write-Host "MessageQueuingConfiguration Failed with following error message :: $ErrorMessage"
	}
     }
 End
 {

     }
 }


MessageQueuingConfiguration $Queues2Create $UserAccess $QueueBasePath