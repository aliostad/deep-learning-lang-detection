<?php

class SupplierApi implements SupplierApiInterface {
	protected $apiUrl;
	protected $apiUsername;
	protected $apiPassword;

	public function getApiUrl() 
	{
		return $this->apiUrl;
	}

	public function setApiUrl($value) 
	{
		$this->apiUrl = $value;
	}

	public function getApiUsername() 
	{
		return $this->apiUsername;
	}

	public function setApiUsername($value) 
	{
		$this->apiUsername = $value;
	}

	public function getApiPassword() 
	{
		return $this->apiPassword;
	}

	public function setApiPassword($value) 
	{
		$this->apiPassword = $value;
	}
}