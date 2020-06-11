<?php
/**
 * 
 * @author psi-pl001
 *
 */ 
class CustomerAddress {
	/**
	 * @var integer
	 */
	private $customer;
	/**
	 * @var integer
	 */
	private $address;
	
	public function __construct($customerAddressData = null) {
		global $db;
		
		if($customerAddressData != null) {
			$this->setCustomer(new Customer($db->getCustomer($customerAddressData['CUSTOMER_CUSTOMER_ID'])));
			$this->setAddress(new Address($db->getAddress($customerAddressData['ADDRESS_ADDRESS_ID'])));
		}
	}

	/**
	 * 
	 * @return Customer
	 */
	public function getCustomer()
	{
	    return $this->customer;
	}

	/**
	 * 
	 * @param $customer
	 */
	public function setCustomer(Customer $customer)
	{
	    $this->customer = $customer;
	}

	/**
	 * 
	 * @return Address
	 */
	public function getAddress()
	{
	    return $this->address;
	}

	/**
	 * 
	 * @param $address
	 */
	public function setAddress($address)
	{
	    $this->address = $address;
	}
}
?>