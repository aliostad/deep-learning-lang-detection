<?php

	include_once DIR_BASE . "dataaccess/customerDA.php";
	include_once DIR_BASE . "model/model.customer.php";

	class CustomerMapper
	{
		private $customerDAO = null;

		function CustomerMapper()
		{
			$this->customerDAO = new CustomerDA();
		}

		public function getCustomers($id = null)
		{
			$customerRet = [];

			$customers = $this->customerDAO->getCustomers($id);

			foreach ($customers as $customer)
			{
				array_push($customerRet, $this->createCustomer($customer));
			}

			return $customerRet;
		}

		public function getCustomerStats($startDate, $endDate, $minValue)
		{
			$customerRet = [];

			$customers = $this->customerDAO->getCustomerStats($startDate, $endDate, $minValue);

			foreach ($customers as $customer)
			{
				array_push($customerRet, $this->createCustomer($customer));
			}

			return $customerRet;
		}

		public function addCustomer($customer)
		{
			$this->customerDAO->addCustomer($customer);
		}

		public function updateCustomer($customer)
		{
			$this->customerDAO->updateCustomer($customer);
		}

		public function deleteCustomer($id)
		{
			$orders = $this->customerDAO->countOrders($id);
			
			if ($orders > 0)
				return "Not possible to delete. The customer is associated to at least 1 order.";
		
			return $this->customerDAO->deleteCustomer($id);
		}

		public function createCustomer($customer)
		{
			$cust = new Customer();

			if(isset($customer['customerId']))
			{
				$cust->id = $customer['customerId'];
				$cust->name = $customer['customerName'];
				$cust->phone = $customer['customerPhone'];
				$cust->addressLine1 = $customer['customerAddressLine1'];
				$cust->addressLine2 = $customer['customerAddressLine2'];
				$cust->city = $customer['customerCity'];
				$cust->state = $customer['customerState'];
				$cust->country = $customer['customerCountry'];
				$cust->postalCode = $customer['customerPostalCode'];
			}

			return $cust;
		}
	}

