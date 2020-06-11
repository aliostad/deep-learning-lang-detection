<?php
class Vdh_Customerurl_Model_Customer_Observer {

	public function addRewritesFromEvent($observer) {
		$customer = $observer->getEvent()->getCustomer();	
		return Mage::getModel('customerurl/customer')->addRewrites($customer);
	}
	
	public function addRewritesFromId($customerId) {
		$customer = Mage::getModel('customer/customer')->load($customerId);
		return (!$customer) ? false : Mage::getModel('customerurl/customer')->addRewrites($customer);		
	}	


	
	public function createUniqueFromEvent($observer) {
		$customer = $observer->getEvent()->getCustomer();
		return Mage::getModel('customerurl/customer')->createUnique($customer);
	}
	public function createUniqueFromId($customerId, $default = 'username') {
		$customer = Mage::getModel('customer/customer')->load($customerId);
		return (!$customer) ? false : Mage::getModel('customerurl/customer')->createUnique($customer, $default);		
	}
	
	
}