<?php

/**
* 
*/

include_once 'inc.api._modules.php';

class API {

	static $apis    = array();
	static $outputs = array();
	var $output; 
	var $tpl;
	
	function __construct($tpl = 'api', $output = 'html') {
		$this->tpl    = $tpl;
		$this->output = API::loadOutput($output);
	}

	public function askApi($requestedApi, $request, $args = array()) {
		$result = '';
		$api;
		if(!is_array($args)){
			$decodedArgs = json_decode($args, true);
			$args        = $decodedArgs != null ? $decodedArgs : $args;
		}

		try {
			if (!isset(API::$apis[$requestedApi])) {
				throw new Exception("No such API: " . $requestedApi, 1);
			}
			$api = API::loadApi($requestedApi);
			$api->get($request, $args);
		} catch (Exception $e) {
			$api = $this->loadApi('error');
			$api->get('', $e);
		}
		$result = $api->answer();
		$this->output($result);
	}

	static public function registerAPi($apiClassName='', $name='') {
		$apiClass = new ReflectionClass($apiClassName);
		API::$apis[($name == '') ? $apiClassName : $name] = $apiClass;
	}

	static public function registerOutput($outputClassName='', $name='') {
		$outputClass = new ReflectionClass($outputClassName);
		API::$outputs[($name == '') ? $outputClassName : $name] = $outputClass;
	}

	static public function loadApi($api) {
		return API::$apis[$api]->newInstance();
	}

	static public function loadOutput($output) {
		return API::$outputs[$output]->newInstance();
	}

	public function output($content)
	{

		$this->output->setArgument(
			'content', 
			$content);

		$this->output->setArgument(
			'template', 
			$content['template']);

		$this->output->setArgument(
			'tplMessage', 
			$content['tplMessage']);

		$this->output->reply();
	}


	public function jsonOutput($content) {
		echo json_encode($content);
	}

	public function getJs($requestedApi) {
		$api = $this->loadApi($requestedApi);
		$this->tpl->assign('api' . $requestedApi . 'js', $requestedApi->getJs());
	}
}


	
?>