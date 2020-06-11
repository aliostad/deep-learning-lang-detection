<?php
namespace Developer\Stuff\Models;
use Developer\PersistenceLayer\AbstractMapper;
use Zend\ServiceManager\ServiceLocatorAwareInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

/**
 * @author Igor Vorobiov<igor.vorobioff@gmail.com>
 */
abstract class AbstractModel implements ModelInterface, ServiceLocatorAwareInterface
{
	private $serviceLocator;

	/**
	 * Set service locator
	 *
	 * @param ServiceLocatorInterface $serviceLocator
	 */
	public function setServiceLocator(ServiceLocatorInterface $serviceLocator)
	{
		$this->serviceLocator = $serviceLocator;
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
	 * @param $name
	 * @return AbstractMapper
	 */
	protected function getRepository($name)
	{
		return $this->getServiceLocator()->get('Repository\\'.$name);
	}
}