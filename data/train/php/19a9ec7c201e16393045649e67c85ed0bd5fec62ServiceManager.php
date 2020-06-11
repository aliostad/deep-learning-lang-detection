<?php namespace MoonSpring\Service;

use MoonSpring\DI\IIOCContainer;

class ServiceManager implements IServiceManager
{
	protected $services = array();
	protected $iocContainer = null;

	public function __construct(IIOCContainer $iocContainer)
	{
		$this->iocContainer = $iocContainer;
	}

	public function __get($service)
	{
		return $this->get($service);
	}

	public function get($service)
	{
		if (isset($this->services[$service]))
			return $this->services[$service];

		return $this->makeService($service);
	}

	protected function makeService($service)
	{
		$newService = $this->iocContainer->resolve($service);
		$this->services[$service] = $newService;

		return $newService;
	}
}