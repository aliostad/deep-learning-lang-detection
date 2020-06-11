<?php
	// Class that deals with customer administration
	class AdminCustomerDetails
	{
		// Public attributes
		public $mCustomers;
		public $mErrorMessage;
		public $mLinkToCustomersAdmin;
		public $mLinkToCustomerAdmin;
		
		// Private attributes
		private $_mCustomerID;
		
		// Class constructor
		public function __construct()
		{				
			// Need to have CustomerID in the query string
			if (!isset ($_GET['CustomerID']))
				trigger_error('CustomerID not set');
			else
				$this->_mCustomerID = (int)$_GET['CustomerID'];

			$this->mLinkToCustomersAdmin = Link::ToCustomersAdmin();
			$this->mLinkToCustomerAdmin = Link::ToCustomerAdmin($this->_mCustomerID);
		}
		
		public function init()
		{	
			// If updating customer info ...
			if (isset ($_POST['UpdateCustomerInfo']))
			{
				$customer_firstname = $_POST['customer_first_name'];
				$customer_surname = $_POST['customer_surname'];
				$customer_email = $_POST['customer_email'];
				$customer_password = $_POST['customer_password'];
				$customer_address_line_one = $_POST['customer_address_line_one'];
				$customer_town = $_POST['customer_town'];
				$customer_city = $_POST['customer_city'];
				$customer_county = $_POST['customer_county'];
				$customer_postcode = $_POST['customer_postcode'];
				$customer_telephone = $_POST['customer_telephone'];
				
				if ($customer_firstname == null)
					$this->mErrorMessage = 'First name is empty';
				if ($customer_surname == null)
					$this->mErrorMessage = 'Surname is empty';
				if ($customer_email == null || !preg_match("/^[_\.0-9a-zA-Z-]+@([0-9a-zA-Z][_\.0-9a-zA-Z-]*)$/i", $customer_email))
					$this->mErrorMessage = 'Please correct the email address';
				if ($customer_password == null)
					$this->mErrorMessage = 'Password is empty';
				if ($customer_address_line_one == null)
					$this->mErrorMessage = 'Street Address is empty';
				if ($customer_town == null)
					$this->mErrorMessage = 'Town is empty';
				if ($customer_city == null)
					$this->mErrorMessage = 'City is empty';
				if ($customer_county == null)
					$this->mErrorMessage = 'County is empty';
				if ($customer_postcode == null || strlen($customer_postcode) > 8)
					$this->mErrorMessage = 'Post code is empty';
				if ($customer_telephone == null || strlen($customer_telephone) > 11)
					$this->mErrorMessage = 'Telephone number is empty';
					
				if ($this->mErrorMessage == null)
				{
					require_once BUSINESS_DIR . 'password_hasher.php';
					
					$hashed_password = PasswordHasher::Hash($customer_password);
					
					if ($hashed_password != $this->mCustomers['password'])
					{
						Customer::UpdateCustomer($this->_mCustomerID, $customer_firstname,
						$customer_surname, $customer_email, $hashed_password, $customer_password, $customer_telephone,
						$customer_address_line_one, $customer_town, $customer_city,
						$customer_county, $customer_postcode);
					}
					else
					{
						Customer::UpdateCustomer($this->_mCustomerID, $customer_firstname,
						$customer_surname, $customer_email, $this->mCustomers['password'], 
						$this->mCustomers['unencPassword'], $customer_telephone,
						$customer_address_line_one, $customer_town, $customer_city,
						$customer_county, $customer_postcode);
					}
				}
			}
			
			// If removing the customer from database ...
			if (isset ($_POST['RemoveFromDatabase']))
			{
				Customer::RemoveCustomer($this->_mCustomerID);
				header('Location: ' . htmlspecialchars_decode(
						$this->mLinkToCustomersAdmin));
				exit();
			}
			
			// Get customer info
			$this->mCustomers = Customer::GetCustomerDetails($this->_mCustomerID);
		}
	}
?>