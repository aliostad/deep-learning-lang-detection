<?php

require_once('../conf/libDB.php');

if(!isset($_POST['customerId']))
{
    die();
}


$customerId         = mysql_real_escape_string($_POST['customerId']);
$customerName       = mysql_real_escape_string($_POST['customerName']);
$customerEmail      = mysql_real_escape_string($_POST['customerEmail']);
$customerAddress    = mysql_real_escape_string($_POST['customerAddress']);
$customerTelephone1 = mysql_real_escape_string($_POST['customerTelephone1']);
$customerTelephone2 = mysql_real_escape_string($_POST['customerTelephone2']);


$dbConnection = dbConnect();
$result = mysql_query("update customers set
                                customerName = '$customerName',
                                customerEmail= '$customerEmail',
                                customerTelephone1 = '$customerTelephone1',
                                customerTelephone2 = '$customerTelephone2',
                                customerAddress = '$customerAddress'
                                where customerId = '$customerId'") 
                                or die("Cant update Customer Details");  

mysql_close($dbConnection);
?>