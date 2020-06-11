[Reflection.Assembly]::LoadWithPartialName("System.Messaging")

function CreateQueue ($queueName, $isTransactional, $isJournalEnabled, $userName, $isAdminUser) 
{
    try {
 
        $label = "private$\"  + $queueName
        $fullQueueName = ".\private$\" + $queueName

        if ([System.Messaging.MessageQueue]::Exists($fullQueueName))
        {
            Write-Host($fullQueueName + " queue already exists")
        }
        else
        {
            $newQ = [System.Messaging.MessageQueue]::Create($fullQueueName, $isTransactional)
            $newQ.Label = $label

            if ($isJournalEnabled)
            { 
                $newQ.UseJournalQueue = $True
            }
 
         
        
            if ($isAdminUser)
            { 
                Write-Host("Setting full permissions for user " + $username + " on queue " + $queueName)
                $newQ.SetPermissions($userName, 
                    [System.Messaging.MessageQueueAccessRights]::FullControl, 
                        [System.Messaging.AccessControlEntryType]::Allow)        
            }
            else
            { 
                Write-Host("Setting limited permissions for user " + $username + " on queue " + $queueName)
                $newQ.SetPermissions($userName, 
                    [System.Messaging.MessageQueueAccessRights]::GenericWrite, 
                    [System.Messaging.AccessControlEntryType]::Allow)
                $newQ.SetPermissions($userName, 
                    [System.Messaging.MessageQueueAccessRights]::PeekMessage, 
                    [System.Messaging.AccessControlEntryType]::Allow)
                $newQ.SetPermissions($userName, 
                    [System.Messaging.MessageQueueAccessRights]::ReceiveJournalMessage, 
                    [System.Messaging.AccessControlEntryType]::Allow)
            }
        }
    }
    catch [Exception] {
       Write-Host $_.Exception.ToString()
      printUsage
    }
}

CreateQueue "TestQueue1" $true $false "Everyone" $true
CreateQueue "TestQueue2" $true $false "Everyone" $true
