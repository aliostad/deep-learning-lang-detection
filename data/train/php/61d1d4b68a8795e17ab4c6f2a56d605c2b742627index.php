<?php
require_once 'config.php';
use rkt\MessageAPI as MessageAPI;
/**
 * @var MessageAPI Description
 */
$api =   MessageAPI\BaseMessageAPI::getAPI( "USER_NAME", "PASSWORD", "API_ID", MessageAPI\BaseMessageAPI::API_HTTP);
$api->initAPI();
$messageId = '';
$messageError = '';
$messageStatus = '';
$accountBalance = '';

try 
{
    $messageId = $api->sendMessage('This is a test mesasge', 'SEND-To-Mobile', array('MO'=>1));
    $messageStatus = $api->getMessageStatus($messageId);
    $accountBalance = $api->getAccountBalance();
}
catch (\Exception $e)
{
    $messageError = $e->getMessage();
}

?>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>SMP-Api test page</title>
    </head>
    <body>
        <?php 
        //TODO
        // Add some examples here
        ?>
    </body>
</html>
