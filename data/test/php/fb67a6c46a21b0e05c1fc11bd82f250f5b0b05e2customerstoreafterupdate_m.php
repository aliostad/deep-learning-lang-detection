<?php

class Customerstoreafterupdate_m extends CI_Model
{
	public function __construct()
	{
		parent::__construct();
		$this->load->database();
	}
	
	public function updateCustomer($username, $password, $customerFname, $customerLname, $customerDob, $customerAge, $customerEmail, $customerPhone, $customerAddress, $customerCCNumber, $customerCCName, $customerBillingAddress, $customerCCCVV, $customerCCExpDate)
	{
		$sql = "Update Customers set password = ?, customerFname = ?, customerLname = ?, customerDob = ?, customerAge = ?, customerEmail = ?, customerPhone = ?, customerAddress = ?, customerCCNumber = ?, customerCCName = ?, customerBillingAddress= ?, customerCCCVV = ?, customerCCExpDate = ? WHERE username = ?;";
		$data = array($password, $customerFname, $customerLname, $customerDob, (int) $customerAge, $customerEmail, $customerPhone, $customerAddress, $customerCCNumber, $customerCCName, $customerBillingAddress, (int) $customerCCCVV, $customerCCExpDate, $username);
		$this->db->query($sql, $data);
	}
}

?>