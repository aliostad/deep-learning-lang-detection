<?php

class Shrim extends HttpReq {
	public $data;
	
	public $apiMethod;
	public $apiUser;
	public $apiKey;
	

	public $url = 'http://shr.im/api/';
	protected $apiVersion = '1.0';
	protected $apiFormat = 'json';
	protected $apiArg;
	
	public function __construct($apiMethod, $arg = null ) {
		$this->apiMethod = $apiMethod;
		$this->apiArg = $arg;
	
	}
	
	protected function before() {
		$this->args['api_user'] = $this->apiUser;
		$this->args['api_key'] = $this->apiKey;
		
		if($this->apiMethod == 'by_domain') {
			$this->args['domain'] = $this->apiArg;
		} elseif ($this->apiMethod == 'by_user') {
			$this->args['user'] = $this->apiArg;
		} elseif ($this->apiMethod == 'view') {
			$this->args['alias'] = $this->apiArg;
		}
		
		$this->url .= $this->apiVersion . '/' . $this->apiMethod . '.' . $this->apiFormat;
	}
	
	protected function success() {
		$this->data = json_decode($this->body, true);
	}
}

?>