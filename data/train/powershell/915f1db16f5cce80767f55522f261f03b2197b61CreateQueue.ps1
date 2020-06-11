function Usage
{
    Write-Host "Usage :"
    Write-Host ""
    Write-Host "    CreateQueue.ps1 <-c,d> <queuename> <Y/N - Private> <user> <all:restrictedPermission> [T:Transactional]"
    Write-Host ""
    exit;
}

$opeartion = $Args[0]
$queuename = ".\" + $Args[1]
$private = $Args[2]
$User = $Args[3]
$permission = $Args[4]
$pTransactional = $Args[5]

if($opeartion -eq $null)
{
    Usage;
}

if(($opeartion -ieq "-c") -and (($queuename -eq ".\") -or ($User -eq $null) -or ($private -eq $null) -or ($permission -eq $null)))
{  
  Usage;  
}
elseif(($opeartion -ieq "-d") -and (($queuename -eq ".\") -or ($private -eq $null) ))
{  
  write-host "Cannot delete queue without queuename."
  Usage;
}


[Reflection.Assembly]::LoadWithPartialName("System.Messaging")


if ($private -ieq "Y")
{ 
  $queuename = ".\private$\" + $Args[1]
}

if ($opeartion -ieq "-c")
{
    if ($pTransactional -ieq "T")
    {
        $transactional = 1
        Write-Host "Creating transactional queue " $queuename
    }
    else
    {
        $transactional = 0
        Write-Host "Creating non-transactional queue " $queuename
    }
    

	if([System.Messaging.MessageQueue]::Exists($queuename))
	{
		Write-Host $queuename " already exists"
		exit
	}
   
    $qb = [System.Messaging.MessageQueue]::Create($queuename, $transactional) 
    
    if($qb -eq $null -or $User -eq "")
    {
		exit
    }    
	
	$qb.label = $queuename    
		
	if ($permission -ieq "all")
	{
		Write-Host "Granting all permissions to "  $User
		$qb.SetPermissions($User, [System.Messaging.MessageQueueAccessRights]::FullControl, [System.Messaging.AccessControlEntryType]::Allow) 
	}
	else
	{
		Write-Host "Restricted Control for user: "  $User
		Write-Host ""
		$qb.SetPermissions($User, [System.Messaging.MessageQueueAccessRights]::DeleteMessage, [System.Messaging.AccessControlEntryType]::Set) 
		$qb.SetPermissions($User, [System.Messaging.MessageQueueAccessRights]::GenericWrite, [System.Messaging.AccessControlEntryType]::Allow) 
		$qb.SetPermissions($User, [System.Messaging.MessageQueueAccessRights]::PeekMessage, [System.Messaging.AccessControlEntryType]::Allow) 
		$qb.SetPermissions($User, [System.Messaging.MessageQueueAccessRights]::ReceiveJournalMessage, [System.Messaging.AccessControlEntryType]::Allow)
	}
}
elseif ($opeartion -ieq "-d")
{
    Write-Host "Delete Queue: " + $queuename
    [System.Messaging.MessageQueue]::Delete($queuename)
}