<?php
namespace Configman\Api;

define(ROOT_PATH, __DIR__ . '/..');
require_once(ROOT_PATH . '/configman.php');

abstract class BaseServiceConfig {
	
	public $service;
	
	public $config_path;
	
	public function __construct($service) {
		require(ROOT_PATH . '/config/config.inc.php');
		
		$this->service = $service;
		$this->config_path = CONF_PATH;
	}
	
	public static function getService($service) {
		$service_class_name = ucfirst($service) . 'Config';
		$service_class = '\\Configman\\Api\\Service\\'.ucfirst($service).'\\'.$service_class_name;
		
		return new $service_class($service);
	} 
	
}