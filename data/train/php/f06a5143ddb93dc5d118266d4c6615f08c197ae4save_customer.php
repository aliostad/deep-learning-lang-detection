<?php

$service_name = $_REQUEST['customer_name'];
$customerAddress = $_REQUEST['customer_address'];
$customerTel = $_REQUEST['customer_tel'];
$customerFax = $_REQUEST['customer_fax'];
include 'conn.php';

$sqlGenerateID = "select max(customer_id) as customer_id from QRC_CUSTOMER_NAME;";
$resultSet = mysql_query($sqlGenerateID);
$row = mysql_fetch_array($resultSet);
if ($row['customer_id'] == null) {
    $sql = "insert into QRC_CUSTOMER_NAME(customer_id,customer_name,customer_address,customer_tel,customer_fax) values('40001','$service_name','$customerAddress','$customerTel','$customerFax')";
} else {
    $sql = "insert into QRC_CUSTOMER_NAME(customer_id,customer_name,customer_address,customer_tel,customer_fax) values('" . ($row['customer_id'] + 1) . "','$service_name','$customerAddress','$customerTel','$customerFax')";
}

$result = @mysql_query($sql);
if ($result) {
    echo json_encode(array('success' => true));
} else {
    echo json_encode(array('msg' => 'Some errors occured.'));
}
?>