<?php

/**
 * Service class
 */
abstract class Service
{
	/**
	 * Initialize service
	 * @param $serviceName string service name
	 * @return Service service
	 */
	public static function init($serviceName)
	{
		// Get service path
		$servicePath = Configuration::getInstance()->getServicePath($serviceName);

		// Check if service exists
		if(file_exists($servicePath)) {
			// Require service
			if(!class_exists(ucfirst($serviceName).'Service')) require($servicePath);

			// Create and return service
			return eval('return new '.ucfirst($serviceName).'Service();');
		} else {
			// Return null
			return null;
		}
	}

	/** @var $request Request request */
	protected $request;

	/**
	 * Start service
	 */
	abstract public function start();

	/**
	 * Get service's ressource
	 */
	abstract public function getRessource();

	/**
	 * Stop service
	 */
	abstract public function stop();
}