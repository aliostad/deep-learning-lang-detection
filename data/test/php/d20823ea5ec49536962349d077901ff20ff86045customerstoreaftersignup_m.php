<?php

class Customerstoreaftersignup_m extends CI_Model
{
	public function __construct()
	{
		parent::__construct();
		$this->load->database();
	}
	public function storeCustomer($username, $password, $customerFname, $customerLname, $customerDob, $customerAge, $customerEmail, $customerPhone, $customerAddress, $customerCCNumber, $customerCCName, $customerBillingAddress, $customerCCCVV, $customerCCExpDate)
	{
		$sql = "Insert into Customers values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NULL);";
		$data = array($username, $password, $customerFname, $customerLname, $customerDob, (int) $customerAge, $customerEmail, $customerPhone, $customerAddress, $customerCCNumber, $customerCCName, $customerBillingAddress, (int) $customerCCCVV, $customerCCExpDate);
		$this->db->query($sql, $data);
	}
}

?>