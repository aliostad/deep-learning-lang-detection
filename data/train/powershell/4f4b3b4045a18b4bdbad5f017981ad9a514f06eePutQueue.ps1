[Reflection.Assembly]::LoadWithPartialName("System.Messaging");

$queueName = '.\Private$\TestQueue1';


$queue = new-object System.Messaging.MessageQueue $queueName;
$utf8 = new-object System.Text.UTF8Encoding;

$tran = new-object System.Messaging.MessageQueueTransaction;
$tran.Begin();

$msgContent = '<xml version="1.0" ?>
    <DummyMessage xmlns="http://dummy">
        <Dummy></Dummy>
    </DummyMessage>';
$msgBytes = $utf8.GetBytes($msgContent);

$msgStream = new-object System.IO.MemoryStream;
$msgStream.Write($msgBytes, 0, $msgBytes.Length);

$msg = new-object System.Messaging.Message;
$msg.BodyStream = $msgStream;
$queue.Send($msg, $tran);

$tran.Commit();