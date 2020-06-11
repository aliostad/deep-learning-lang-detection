<?php

class SmAuth {
	
	private $api_token;
	private $api_secret;

	public function __construct($_api_token, $_api_secret)
	{
		$this->api_token = $_api_token;
		$this->api_secret = $_api_secret;
	}

	public function getApiToken()
	{
		return $this->api_token;
	}

	public function getApiSecret()
	{
		return $this->api_secret;
	}

	public function setApiToken($_api_token)
	{
		$this->api_token = $_api_token;
	}

	public function setApiSecret($_api_secret)
	{
		$this->api_secret = $_api_secret;
	}

	public function generateCsrf($params)
	{
		return md5($this->getApiToken().'.'.$this->getApiSecret());
	}

}