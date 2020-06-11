<?php
include("connection.php");
		
		if($_POST['customer_id'])
{
$customer_id=mysql_escape_String($_POST['customer_id']);
$customer_name=mysql_escape_String($_POST['customer_name']);
$customer_address=mysql_escape_String($_POST['customer_address']);
$customer_city=mysql_escape_String($_POST['customer_city']);
$customer_zip_code=mysql_escape_String($_POST['customer_zip_code']);
$customer_tin=mysql_escape_String($_POST['customer_tin']);
$customer_account=mysql_escape_String($_POST['customer_account']);
$customer_phone_number=mysql_escape_String($_POST['customer_phone_number']);
$customer_fax=mysql_escape_String($_POST['customer_fax']);
$customer_vat_status=mysql_escape_String($_POST['customer_vat_status']);
$sql = "update customer set customer_name='$customer_name',customer_address='$customer_address',customer_city='$customer_city'
,customer_zip_code='$customer_zip_code',customer_tin='$customer_tin',customer_account='$customer_account'
,customer_phone_number='$customer_phone_number',customer_fax='$customer_fax',customer_vat_status='$customer_vat_status' where customer_id='$customer_id'";
mysql_query($sql);
}
?>