<?php
namespace Frame\Service;

class ServiceManager
{
	protected $config = array();
	
	protected $services = array();
	
	protected $instances = array();
	
	public function __construct($config = array(), ServiceManagerConfigInterface $serviceManagerConfig = null)
	{
		$this->config = $config;
		if (null !== $serviceManagerConfig) {
			$serviceManagerConfig->configureServiceManager($this);
		}
	}
	
	public function registerService($serviceName, $service)
	{
		if (!is_string($service)) {
			throw new \Exception(sprintf("Service '%s''s class must be string.", $serviceName));
		}
		$this->services[$serviceName] = $service;
	}
	
	public function getService($serviceName, $shared = true)
	{
		if (true === $shared) {
			if (!isset($this->instances[$serviceName])) {
				$this->instances[$serviceName] = $this->createService($serviceName);
			}
			return $this->instances[$serviceName];
		}
		return $this->createService($serviceName);
	}
	
	protected function createService($serviceName)
	{
		if (!isset($this->services[$serviceName])) {
			throw new \Exception(sprintf("Service '%s' has not been registered.", $serviceName));
		}
		$serviceFactoryName = $this->services[$serviceName];
		if (!class_exists($serviceFactoryName)) {
			throw new \Exception(sprintf("Service '%s''s class '%s' not found.", $serviceName, $serviceFactoryName));
		}
		$serviceFactory = new $serviceFactoryName();
		if (!$serviceFactory instanceof ServiceFactoryInterface) {
			throw new \Exception(sprintf("Service '%s''s class '%s' must implements '%s'.", $serviceName, $serviceFactoryName, 'Frame\Service\ServiceFactoryInterface'));
		}
		$instance = call_user_func(array($serviceFactory, 'createService'), $this);
		return $instance;
	}
	
	public function getServiceConfig($optionName, $default = '')
	{
		return isset($this->config[$optionName]) ? $this->config[$optionName] : $default;
	}
}