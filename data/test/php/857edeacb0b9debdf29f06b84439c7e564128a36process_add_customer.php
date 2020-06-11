<?php

error_reporting(E_ALL ^ (E_NOTICE | E_WARNING));
require '../../includes/session_validator.php';
require '../../config/config.php';
require '../../functions/general_functions.php';

$customerName = clean($_POST['customerName']);
$customerContactPerson = clean($_POST['customerContactPerson']);
$customerContactFirstName = clean($_POST['customerContactFirstName']);
$customerAddress = clean($_POST['customerAddress']);
$customerPhone = clean($_POST['customerPhone']);
$customerFax = clean($_POST['customerFax']);
$customerEmail = clean($_POST['customerEmail']);
if (!empty($_POST['isQuick']))
    $isQuick = $_POST['isQuick'];

$query_customer = "INSERT INTO customer
                                (`customerName`, `customerContactPerson`,
                                `customerContactFirstName`, `customerAddress`,
                                `customerPhone`, `customerFax`, `customerEmail`)
                         VALUES ('$customerName', '$customerContactPerson',
                                 '$customerContactFirstName', '$customerAddress',
                                 '$customerPhone', '$customerFax', '$customerEmail')";

$result_customer = mysqli_query($link, $query_customer) or die(mysqli_error($link));

if ($isQuick) {

    $customer['customerID'] = mysqli_insert_id($link);
    $customer['customerName'] = $customerName;
    echo json_encode($customer);
} else {
    if ($result_customer) {
        info('message', 'Customer added successfully!');
        header('Location: add_customer.php');
    } else {
        info('error', 'Cannot add customer, Please try again');
        header('Location: add_customer.php');
    }
}
?>
