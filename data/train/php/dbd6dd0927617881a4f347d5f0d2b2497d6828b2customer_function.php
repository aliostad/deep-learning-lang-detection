<?php
/* Copyright c 2003-2004 Wang, Chun-Pin All rights reserved.
 *
 * Version:	$Id: customer_function.php,v 1.3 2008/11/28 10:36:49 alex Exp $
 *
 */
class customerclass {
	var $customer_id;
	var $customer_name;
	
	function setcustomerid($id) {
		$this->customer_id = $id;
	}
	function setcustomername($name) {
		$this->customer_name = $name;
	}
	function getcustomerid() {
		return $this->customer_id;
	}
	function getcustomername() {
		return $this->customer_name;
	}
}

function GetAllCustomers()
{
	$sql = "select * from ".$GLOBALS['BR_customer_table']." order by customer_name";
	$result = $GLOBALS['connection']->Execute($sql) or DBError(__FILE__.":".__LINE__);
	$customer_array = array();
	while ($row = $result->FetchRow()) {
		$customer_id = $row["customer_id"];
		$customer_name = $row["customer_name"];
		$new_customer = new customerclass;
		$new_customer->setcustomerid($customer_id);
		$new_customer->setcustomername($customer_name);
		array_push($customer_array, $new_customer);
	}
	$result->Free();

	return $customer_array;
}

function GetCustomerNameFromID($customer_array, $customer_id)
{
	for ($i = 0; $i < sizeof($customer_array); $i++) {
		if ($customer_array[$i]->getcustomerid() == $customer_id) {
			return $customer_array[$i]->getcustomername();
		}
	}
	return "";
}

?>
