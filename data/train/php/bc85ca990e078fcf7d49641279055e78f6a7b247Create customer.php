<?php
require_once('../../Paybrick/http_api_request.php');

// Create new customer
$request = array(
    'action' => 'createCustomer', 
    'create_customer_firstname' => '',   
	'create_customer_lastname' => '',
	'create_customer_company' => '',
	'create_customer_email' => '',
	'create_customer_address_line1' => '',
	'create_customer_address_line2' => '', // optional
	'create_customer_zipcode' => '',
	'create_customer_city' => '',
	'create_customer_stateprovince' => '',
	'create_customer_country_iso2' => '',
	'create_customer_language' => '',
	'create_customer_phone' => '',
	'create_customer_vatnumber' => '',
	'create_customer_balance' => '0', // in cents
	'create_customer_ip' => ''
 );
 
// create customer & return a customer ID that you can store in your DB.
$Paybrick_result = http_api_request($request);

if($Paybrick_result->{'error_message'} == '') {
	echo $Paybrick_result->{'customer_id'};	
	}
else
{
echo $Paybrick_result->{'error_message'};
}
?>
