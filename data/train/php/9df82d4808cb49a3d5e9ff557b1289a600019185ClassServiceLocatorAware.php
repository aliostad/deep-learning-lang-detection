<?php

namespace Services\Service;

use Zend\ServiceManager\ServiceLocatorAwareInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use Zend\ServiceManager\ServiceManager;

/**
 * Пользовательский класс, реализующий интерфейс ServiceLocatorAwareInterface,
 * благодаря чему он получает доступ к ServiceManager, внедрённом в его свойство $serviceLocator
 */
class ClassServiceLocatorAware implements ServiceLocatorAwareInterface {

	protected $serviceLocator;	// ServiceLocatorInterface

	/**
	 * @see \Zend\ServiceManager\ServiceLocatorAwareInterface::setServiceLocator()
	 */
	function setServiceLocator( ServiceLocatorInterface $serviceLocator ) {
		$this->serviceLocator = $serviceLocator;
	}
	/**
	 * @see \Zend\ServiceManager\ServiceLocatorAwareInterface::getServiceLocator()
	 */
	function getServiceLocator() {
		if (null === $this->serviceLocator)
			$this->setServiceLocator(new ServiceManager());
		return $this->serviceLocator;
	}

	function getGreeting() {
		return __CLASS__ .'-'. $this->getServiceLocator()->get('Services\Service\GreetingService')->getGreeting();
	}
}
