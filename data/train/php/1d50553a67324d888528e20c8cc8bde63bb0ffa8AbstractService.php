<?php

namespace Extend\Service;

use Doctrine\ORM\EntityManager;

use Zend\ServiceManager\ServiceManager;
use Zend\ServiceManager\ServiceManagerAwareInterface;

abstract class AbstractService implements ServiceManagerAwareInterface
{
	/**
	 * @var ServiceManager
	 */
	protected $serviceManager;

	/**
	 * @var EntityManager
	 */
	protected $entityManager;

	/**
	 * @var AuthenticationService
	 */
	protected $authenticationService;


	/**
	 * @param ServiceManager $serviceManager
	 * @return AbstractService
	 */
	public function setServiceManager(ServiceManager $serviceManager)
	{
		$this->serviceManager = $serviceManager;
		return $this;
	}

	/**
	 * @return ServiceManager
	 */
	public function getServiceManager()
	{
		return $this->serviceManager;
	}

	/**
	 * @return EntityManager
	 */
	public function getEntityManager()
	{
		if (!$this->entityManager) {
			$this->entityManager = $this->serviceManager->get('doctrine.entitymanager.orm_default');
		}

		return $this->entityManager;
	}
}