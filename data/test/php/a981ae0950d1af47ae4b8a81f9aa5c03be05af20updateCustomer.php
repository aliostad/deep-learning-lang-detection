<?php
include '../connection.php';

$customer_ID   	  = mysqli_real_escape_string($link, $_POST['customer_ID']);
$customer_name 	  = mysqli_real_escape_string($link, $_POST['customer_name']);
$customer_address = mysqli_real_escape_string($link, $_POST['customer_address']);
$customer_phone   = mysqli_real_escape_string($link, $_POST['customer_phone']);
$customer_email   = mysqli_real_escape_string($link, $_POST['customer_email']);
$customer_fax 	  = mysqli_real_escape_string($link, $_POST['customer_fax']);
$customer_contact = mysqli_real_escape_string($link, $_POST['customer_contact']);
$customer_notes   = mysqli_real_escape_string($link, $_POST['customer_notes']);

// check if the customer_ID is valid
$sqlError = "SELECT customer_ID
						 FROM customer
						 WHERE customer_ID = '$customer_ID' ;";
$sqlErrorResult = mysqli_query($link, $sqlError);

if(mysqli_num_rows($sqlErrorResult) == 0){
	die("invalid ID");
}
// allows us to use ',' instead of 'SET' when making the SQL string
$sql = "UPDATE customer SET customer_name = customer_name";

if(!empty($customer_name)){
	$sql .= ", customer_name = '$customer_name'";
}
if(!empty($customer_address)){
	$sql .= ", customer_address = '$customer_address'";
}
if(!empty($customer_phone)){
	$sql .= ", customer_phone = '$customer_phone'";
}
if(!empty($customer_email)){
	$sql .= ", customer_email = '$customer_email'";
}
if(!empty($customer_fax)){
	$sql .= ", customer_fax = '$customer_fax'";
}
if(!empty($customer_contact)){
	$sql .= ", customer_contact = '$customer_contact'";
}
if(!empty($customer_notes)){
	$sql .= ", customer_notes = '$customer_notes'";
}

$sql .= " WHERE customer_ID = '$customer_ID';";

$result = mysqli_query($link, $sql);
?>
