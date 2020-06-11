<?php
/**
 * User: dpeuscher
 * Date: 11.03.13
 */
namespace DpZFExtensions\ServiceManager;

use Zend\ServiceManager\Config;
use Zend\ServiceManager\ServiceLocatorInterface;
use Zend\ServiceManager\ServiceManager;

trait TServiceLocator {
	/**
	 * @var ServiceLocatorInterface
	 */
	protected $_serviceLocator;
	/**
	 * Set service locator
	 *
	 * @param ServiceLocatorInterface $serviceLocator
	 */
	public function setServiceLocator(ServiceLocatorInterface $serviceLocator)
	{
		$this->_serviceLocator = $serviceLocator;
	}

	/**
	 * Get service locator
	 *
	 * @return ServiceLocatorInterface
	 */
	public function getServiceLocator()
	{
		if (is_null($this->_serviceLocator))
			$this->_serviceLocator = new ServiceManager(new Config()); //ServiceLocatorFactory::getInstance();
		return $this->_serviceLocator;
	}

}
