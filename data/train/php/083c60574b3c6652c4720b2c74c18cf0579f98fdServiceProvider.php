<?php

namespace Neonium\Dependency;

use Neonium\Core\Object;
use Neonium\Exceptions\ServiceException;

class ServiceProvider extends Object
{
	private $__registeredServices = [];
	private $__activeServices = [];

	public function __construct(array $aliases)
	{
		foreach($aliases as $ak => $av)
		{
			$this->register($ak, $av);
		}
	}

	/**
	 * @param $serviceName
	 * @param $serviceClass
	 * @return void
	 * @throws ServiceException
	 */
	public function register($serviceName, $serviceClass)
	{
		if( array_key_exists($serviceName, $this->__registeredServices) )
			throw new ServiceException("Service is already registred.");

		$this->__registeredServices[$serviceName] = $serviceClass;
	}

	/**
	 * @param string $serviceName
	 * @return Service
	 * @throws ServiceException
	 */
	public function resolve($serviceName)
	{
		if( !array_key_exists($serviceName, $this->__registeredServices) )
			throw new ServiceException("Service alias is not registered to be resolved.");

		if( !array_key_exists($serviceName, $this->__activeServices) )
		{
			$serviceClassFQName = explode('.', $this->__registeredServices[$serviceName]);
			$serviceClassFQName = '\\' . implode('\\', $serviceClassFQName);
			//$serviceObject = $serviceClosure($this);
			$this->__activeServices[$serviceName] = new $serviceClassFQName($this);
		}

		return $this->__activeServices[$serviceName];
	}
}

?>