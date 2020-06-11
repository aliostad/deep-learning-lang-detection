<?php

require '../../includes/session_validator.php';
require '../../config/config.php';
require '../../functions/general_functions.php';

$customerID = clean_arr($_POST['customerID']);
$customerName = clean_arr($_POST['customerName']);
$customerContactPerson = clean_arr($_POST['customerContactPerson']);
$customerContactFirstName = clean_arr($_POST['customerContactFirstName']);
$customerAddress = clean_arr($_POST['customerAddress']);
$customerPhone = clean_arr($_POST['customerPhone']);
$customerFax = clean_arr($_POST['customerFax']);
$customerEmail = clean_arr($_POST['customerEmail']);

for ($i = 0; $i < count($customerID); $i++) {
    $query_customer = "UPDATE customer
                      SET `customerName` = '$customerName[$i]',
                          `customerContactPerson` = '$customerContactPerson[$i]',
                          `customerContactFirstName` = '$customerContactFirstName[$i]',
                          `customerAddress` = '$customerAddress[$i]',
                          `customerPhone` = '$customerPhone[$i]',
                          `customerFax` = '$customerFax[$i]',
                          customerEmail = '$customerEmail[$i]'
                    WHERE `customerID` = '$customerID[$i]'";

    $result_customer = mysqli_query($link, $query_customer) or die(mysqli_error($link));
}

if ($result_customer) {
    info('message', 'Customer(s) updated successfully!');
    header('Location: customers.php');
} else {
    info('error', 'Cannot update customer(s), Please try again');
    header('Location: customers.php');
}
?>
