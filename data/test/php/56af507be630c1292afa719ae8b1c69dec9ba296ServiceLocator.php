<?php
namespace Scotch;

use Scotch\System as System;
use Scotch\Utilities\Utilities as Utilities;
use Scotch\Exceptions\MissingServiceException as MissingServiceException;
use Scotch\Exceptions\ClassNotFoundException as ClassNotFoundException;

class ServiceLocator
{
	protected $services = array();
	
	function __construct()
	{
	}
	
	function getService($serviceName,$parameters = null)
	{
		$service = null;
		
		if(isset($this->services[$serviceName]))
		{
			$service = $this->services[$serviceName];
		}
		else
		{
			$services = System::$application->getServiceTable();
			$serviceClass = Utilities::getInstance()->getValue($services,$serviceName);
			
			if(isset($serviceClass))
			{
				$service = new $serviceClass($parameters);
				$this->services[$serviceName] = $service;
			}
			else
			{
				throw new MissingServiceException("The service $serviceName does not exist");
			}
		}
		return $service;
	}
}
?>