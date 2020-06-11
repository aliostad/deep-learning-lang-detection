<?php

namespace Application\Service;

use Zend\ServiceManager\ServiceLocatorAwareInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class Example implements ServiceLocatorAwareInterface
{
	protected $serviceLocator;

	public function setServiceLocator(ServiceLocatorInterface $serviceLocator)
	{
		$this->serviceLocator = $serviceLocator;
		return $this;
	}

	public function getServiceLocator()
	{
		return $this->serviceLocator;
	}

	public function encodeMyString($string)
	{
		return str_rot13($string);
	}
}