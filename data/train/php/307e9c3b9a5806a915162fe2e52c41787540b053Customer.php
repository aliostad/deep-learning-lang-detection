<?php

namespace HechoEnDrupal\ComproPago;

class Customer implements CustomerInterface{

	public function __construct(array $customer){

		$this->setCustomerPhone($customer['customer_phone']);
		$this->setCustomerCompanyPhone($customer['customer_company_phone']);

	}

	public function getCustomerPhone(){
		return $this->customer_phone;
	}

	public function setCustomerPhone($phone){
		$this->customer_phone = $phone;
	}

	public function getCustomerCompanyPhone(){
		return $this->customer_company_phone;
	}

	public function setCustomerCompanyPhone($company){
		return $this->customer_company_phone = $company;
	}

}