<?php
class CustomersService {
	/**
	 * Get Customer's List
	 * @return array
	 */
	public function getCustomerList(){		
		$dbAdapter = ManageDatabase::getDbAdapter();
		$select = $dbAdapter->select()->from('customers');
		$stmt = $dbAdapter->query($select);
		return $stmt->fetchAll();
	}
	
	/**
	 * 
	 * Add Customer in Customer's List
	 * @param Customer $customer
	 * @return String $id
	 */
	public function addCustomer($customer){
		$customerData = CustomersService::setCustomerData($customer);
		$dbAdapter = ManageDatabase::getDbAdapter();
		Zend_Db_Table::setDefaultAdapter($dbAdapter);
		$customerTable = new Zend_Db_Table('customers');
		return $customerTable->insert($customerData);
	}
	
	/**
	 * Delete Customer from Customers' List
	 * @param Customer $customer
	 * @return int the number of row affected
	 */
	public function deleteCustomer($customer){
		$dbAdapter = ManageDatabase::getDbAdapter();
		Zend_Db_Table::setDefaultAdapter($dbAdapter);
		$customerTable = new Zend_Db_Table('customers');
		$where = $customerTable->getAdapter()->quoteInto('id= ?', $customer->id);
		return $customerTable->delete($where);
	}
	
	/**
	 * Save Customer's Changes
	 * @param Customer $customer
	 * @return String $id
	 */
	public function saveChangesCustomer($customer){
		$dbAdapter = ManageDatabase::getDbAdapter();	
		Zend_Db_Table::setDefaultAdapter($dbAdapter);
		$customerTable = new Zend_Db_Table('customers');
		$customerData = CustomersService::setCustomerData($customer);
		$where = $customerTable->getAdapter()->quoteInto('id= ?', $customer->id);
		return $customerTable->update($customerData, $where);
	}
	
	/**
	 * Set customer data	 
	 * @param Customer $customer
	 */
	private function setCustomerData($customer){
		$customerData=array(
			'firstname' => $customer->firstName,
			'lastname' => $customer->lastName,
			'email' => $customer->email,
			'telephone_number' => $customer->telephoneNumber
		);
		return $customerData;
	}

}

?>