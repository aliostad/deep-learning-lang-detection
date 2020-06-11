<?php

require '../config/config.php';
require '../functions/general_functions.php';

$customerID = clean($_POST['customerID']);

$query_customer = "SELECT c.`customerID`, `customerName`, `customerContactPerson`, 
                          `customerContactFirstName`, `customerAddress`, `customerPhone`,
                          `customerFax`, `customerEmail`
                     FROM customer c
                    WHERE c.`customerID` = '$customerID'";

$result_customer = mysqli_query($link, $query_customer) or die(mysqli_error($link));

$row_customer = mysqli_fetch_array($result_customer);

$customer['customerName'] = $row_customer['customerName'];
$customer['customerContactPerson'] = $row_customer['customerContactPerson'];
$customer['customerContactFirstName'] = $row_customer['customerContactFirstName'];
$customer['customerAddress'] = $row_customer['customerAddress'];
$customer['customerPhone'] = $row_customer['customerPhone'];
$customer['customerFax'] = $row_customer['customerFax'];
$customer['customerEmail'] = $row_customer['customerEmail'];

echo json_encode($customer);
?>
