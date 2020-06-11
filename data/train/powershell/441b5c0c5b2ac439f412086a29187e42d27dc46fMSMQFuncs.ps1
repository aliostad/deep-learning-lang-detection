[Reflection.Assembly]::LoadWithPartialName("System.Messaging") | Out-Null

function Get-MSMQueue($QueueName, $ServerName = ".")
{
    if ([String]::IsNullOrEmpty($ServerName) -or $ServerName -eq ".")
    {
        $TargetServer = "."
    }
    else
    {
        $TargetServer = "FormatName:Direct=OS:$ServerName"
#        New-Object System.Messaging.MessageQueue("$TargetServer\private$\$QueueName",([System.Messaging.QueueAccessMode]::Send))
    }
    New-Object System.Messaging.MessageQueue("$TargetServer\private$\$QueueName")
}

function Create-MSMQueue($QueueName)
{
    $q = [System.Messaging.MessageQueue]::Create(".\private$\$QueueName")
    $q.SetPermissions("Все", [System.Messaging.MessageQueueAccessRights]::FullControl, [System.Messaging.AccessControlEntryType]::Set)
    $q.SetPermissions("АНОНИМНЫЙ ВХОД", [System.Messaging.MessageQueueAccessRights]::FullControl, [System.Messaging.AccessControlEntryType]::Set)
    $q
}

function Test-MSMQueue($QueueName)
{
    try
    {
        [System.Messaging.MessageQueue]::Exists(".\private$\$QueueName")
    }
    catch
    {
        $false
    }
}

function Test-MSMQueueRemote($QueueName, $ServerName)
{
    $q = Get-MSMQueue $QueueName $ServerName
    try
    {
        $msgcount = $q.getallmessages().length
        $true
    }
    catch
    {
        $false
    }
}

function Send-MSMQMessage($Queue, $Message)
{
    $msg = new-object System.Messaging.Message $Message
    $msg.Label = $Message.GetType().FullName

    $Queue.Send($msg)
}

function Add-MSMQTargetTypes($Queue, $MessageTypes)
{
    $MessageTypes | %{ $Queue.Formatter.TargetTypes += [Type]$_ }
}

function Set-MSMQReadProperties($Queue)
{
    $Queue.MessageReadPropertyFilter.ArrivedTime = $true
    $Queue.MessageReadPropertyFilter.SentTime = $true
}

function Peek-MSMQMessage($Queue)
{
    try
    {
        $Queue.Peek((New-TimeSpan -Seconds 1))
    }
    catch{}
}

function Receive-MSMQMessage($Queue)
{
    try
    {
        $Queue.Receive((New-TimeSpan -Seconds 1))
    }
    catch{}
}

function Purge-MSMQueue($Queue)
{
    $Queue.Purge()
}
