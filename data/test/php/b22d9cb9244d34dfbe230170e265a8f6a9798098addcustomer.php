<?php
//验证登陆信息
session_start();
include_once 'conn.php';
//if($_POST['submit']){
	$customer_name=$_POST['customer_name'];
	$customer_phone=$_POST['customer_phone'];
	$customer_email=$_POST['customer_email'];
	$customer_company=$_POST['customer_company'];
	$customer_address=$_POST['customer_address'];
	$customer_other=$_POST['customer_other'];
	$customer_type=$_POST['customer_type'];

	//$sql="INSERT INTO user (customer_name, customer_phone, customer_email, customer_company, customer_address, customer_other, customer_type) VALUES ('$_POST[username]','$_POST[realname]','$_POST[phone]')";

	$sql="insert into customer (customer_name, customer_phone, customer_email, customer_company, customer_address, customer_other, customer_type) values('$customer_name','$customer_phone','$customer_email','$customer_company','$customer_address','$customer_other','$customer_type')";
	$query=mysql_query($sql);	
	if ($query==false){		
		echo "<script language='javascript'>alert('相同客户已经存在，插入失败！');location='../添加客户.html';</script>";		
	} else {
		echo "<script language='javascript'>location='../客户列表.html';</script>";
	}
	mysql_close($conn);
//}
?>