<?php

namespace SynrgApi\RateLimit;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorAwareInterface;
use Zend\ServiceManager\ServiceLocatorInterface;


class RateLimitServiceFactory implements ServiceLocatorAwareInterface, FactoryInterface
{

	protected $serviceLocator = NULL;

	/**
	 * Set service locator
	 *
	 * @param ServiceLocatorInterface $serviceLocator
	 * @return $this
	 */
	public function setServiceLocator(ServiceLocatorInterface $serviceLocator)
	{
		$this->serviceLocator = $serviceLocator;
		return $this;
	}

	/**
	 * Get service locator
	 *
	 * @return ServiceLocatorInterface
	 */
	public function getServiceLocator()
	{
		return $this->serviceLocator;
	}

	/**
	 * Create service
	 *
	 * @param ServiceLocatorInterface $serviceLocator
	 * @return mixed
	 */
	public function createService(ServiceLocatorInterface $serviceLocator)
	{

		$this->serviceLocator = $serviceLocator;

		$redisAdapter = $this->getServiceLocator()->get('SynrgAdmin\\Redis\\RateLimit');
		$clientConfig = $this->getServiceLocator()->get('SynrgAdmin\\RateLimit\\ClientConfig');

		$service = new RateLimitService();
		$service->setStorageAdapter($redisAdapter);
		$service->setClientConfig($clientConfig->fetch());

		return $service;
	}

}