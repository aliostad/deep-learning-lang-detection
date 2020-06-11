<?php
class Gama_Customer_Model_Api2_Customer_Rest_Guest_V1 extends Gama_Locality_Model_Api2_Pickuppoint {
	protected function _create($filteredData) {
		$validator = Mage::getResourceModel ( 'api2/validator_fields', array (
				'resource' => $this 
		) );
                
		if (! $validator->isValidData ( $filteredData )) {
			foreach ( $validator->getErrors () as $error ) { 
				$this->_error ( ucfirst($error), Mage_Api2_Model_Server::HTTP_BAD_REQUEST );
			}
			return;
		}
		
		$customer = $this->_getCustomer ();
		
		try {
			$errors = $this->_getCustomerErrors ( $customer, $filteredData );
						
			if (! empty ( $errors )) {
				foreach ( $errors as $error ) {
					$this->_error ( $error, Mage_Api2_Model_Server::HTTP_BAD_REQUEST );
				}
				return ;
			}
			
			if (empty ( $errors )) {
				$customer->cleanPasswordsValidationData ();
				$customer->save ();
				return;
			}
		} catch ( Mage_Core_Exception $e ) {
			if ($e->getCode() === Mage_Customer_Model_Customer::EXCEPTION_EMAIL_EXISTS) {
				throw new Mage_Core_Exception('Email already exists');
            }

		} catch ( Exception $e ) {

		}
	}
	
	/**
	 * Get Customer Model
	 *
	 * @return Mage_Customer_Model_Customer
	 */
	protected function _getCustomer() {
		$customer = $this->_getModel ( 'customer/customer' )->setId ( null );
		/**
		 * Initialize customer group id
		 */
		$customer->getGroupId ();
		
		return $customer;
	}
	
	/**
	 * Validate customer data and return errors if they are
	 *
	 * @param Mage_Customer_Model_Customer $customer        	
	 * @return array|string
	 */
	protected function _getCustomerErrors($customer, $customerData) {
       	$errors = array ();
		$customerForm = $this->_getCustomerForm ( $customer );
		$customerData = $this->_manipulateCustomerData($customerData);
		$customerErrors = $customerForm->validateData ( $customerData );
		
		if (is_array ( $customerErrors )) {
			$errors = array_merge($customerErrors);
		}
		$password = isset($customerData ['password']) ? $customerData ['password'] : NULL;
		$confirmation = isset($customerData ['confirmation']) ? $customerData ['confirmation'] : NULL;
		
		$customerForm->compactData ( $customerData );
		$customer->setPassword ( $password );
		$customer->setPasswordConfirmation ( $confirmation );
		$customerErrors = $customer->validate ();
		if (is_array ( $customerErrors )) {
			$errors = array_merge($customerErrors);
		}

		if($this->_mobileExists($customerData)) {
       	   array_push($errors,'Mobile number already exists');
        } 
		
		return $errors; 
	}
	protected function _getCustomerForm($customer) {
		/* @var $customerForm Mage_Customer_Model_Form */
		$customerForm = $this->_getModel ( 'customer/form' );
		$customerForm->setFormCode ( 'customer_account_create' );
		$customerForm->setEntity ( $customer );
		return $customerForm;
	}
	
	/**
	 * Get model by path
	 *
	 * @param string $path        	
	 * @param array|null $arguments        	
	 * @return false|Mage_Core_Model_Abstract
	 */
	public function _getModel($path, $arguments = array()) {
		return Mage::getModel ( $path, $arguments );
	}
	
	public function _manipulateCustomerData($customerData)
	{
		if(isset($customerData['name'])) {
			$names = $this->_spiltName($customerData['name']);
			unset($customerData['name']);
			$customerData = array_merge($customerData, $names);
		}

		return $customerData;
	}
	
	public function _spiltName($name)
	{
		$spiltNames = explode(' ', $name);
		$names = array();
		if(isset($spiltNames[0])) {
			$names['firstname'] = $spiltNames[0]; 
		}
		
		if(isset($spiltNames[1])) {
			$names['lastname'] = $spiltNames[1];
		}

		return $names;
	}

	public function _mobileExists($customerData) {

        $customerMobile = $customerData['mobile'];

		$mobile = Mage::getModel('customer/customer')
              ->getCollection()
              ->addAttributeToFilter('mobile', $customerMobile)
              ->load();
        $result=$mobile->getData();
        if(isset($result[0]['mobile'])) {
        	return true;
        } else {
        	return false;
        }


    } 


}