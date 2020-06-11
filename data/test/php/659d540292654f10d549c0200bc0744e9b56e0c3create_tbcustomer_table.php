<?php 

include('steadFast.class.php'); 

$sql = "CREATE TABLE tbcustomer(
						customer_snum INT,
						customer_name VARCHAR(255),
						customer_code VARCHAR(255),
						customer_email VARCHAR(255),
						customer_cnum VARCHAR(255),
						customer_fnum VARCHAR(255),
						customer_baddr VARCHAR(255),
						customer_daddr VARCHAR(255),
						customer_contact VARCHAR(255),
						customer_terms VARCHAR(255),
						customer_vat VARCHAR(255)
						);";
						
$app = new steadFast();
$app->executeQuery($sql)

?>