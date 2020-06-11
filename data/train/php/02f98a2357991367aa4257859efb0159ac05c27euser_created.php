<?php
$customer_nm=$_POST['customer_nm'];
$customer_uname=$_POST['customer_uname'];
$customer_pwd= md5($_POST['customer_pwd']);
$customer_almt=$_POST['customer_almt'];
$customer_prov=$_POST['customer_prov'];
$customer_kdpos=$_POST['customer_kdpos'];
$customer_telp=$_POST['customer_telp'];
?>
<?php
include 'config.php';
?>

<?php
$qry=mysql_query("INSERT INTO customer(customer_id,customer_nm,customer_uname,customer_pwd,customer_almt,customer_prov,
	customer_kdpos,customer_telp)VALUES ('','$customer_nm','$customer_uname','$customer_pwd','$customer_almt',
	'$customer_prov','$customer_kdpos','$customer_telp')", $con);
if(!$qry)
{
die("Query Failed: ". mysql_error());
}
else
{
?><script language="javascript">
			alert("User Sukses Di Buat!!");
			document.location="index.php?id=viewall";
			</script><?
}
?>
