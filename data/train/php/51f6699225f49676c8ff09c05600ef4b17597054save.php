<?php

	$cName = $_POST['customer_groups_name'];
	$credit = $_POST['customer_groups_credit'];
	$customersId = (isset($_POST['selectedCustomer']) ? $_POST['selectedCustomer'] : array());

	$CustomerGroups = Doctrine_Core::getTable('CustomerGroups');
	if (isset($_GET['cID'])){
		$CustomerGroups = $CustomerGroups->find((int)$_GET['cID']);
	}else{
		$CustomerGroups = new CustomerGroups();
	}
	if (isset($_GET['cID'])){
		$QdeleteExistingCustomer = Doctrine_Query::create()
		->delete('CustomersToCustomerGroups')
		->where('customer_groups_id=?', $_GET['cID'])
		->execute();
	}

	$CustomerGroups->customer_groups_name = $cName;
	$CustomerGroups->customer_groups_credit = $credit;
	$CustomerGroups->save();

	foreach($customersId as $iCustomer){
		$insertCustomer = new CustomersToCustomerGroups();
		$insertCustomer->customers_id = $iCustomer;
		$insertCustomer->customer_groups_id = $CustomerGroups->customer_groups_id;
		$insertCustomer->save();
	}
	
	EventManager::attachActionResponse(itw_app_link(tep_get_all_get_params(array('action', 'cID')) . 'cID=' . $CustomerGroups->customer_groups_id, null, 'default'), 'redirect');
?>