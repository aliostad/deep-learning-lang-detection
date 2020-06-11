<?php

namespace Edelberg\Manager;

use \Application\Model\DAOs\UserDAO;
use Zend\ServiceManager\ServiceLocatorInterface;
use Zend\ServiceManager\ServiceLocatorAwareInterface;

abstract class BasicManager implements ServiceLocatorAwareInterface, SingleManagerInterface {

    /**
     * @var \Zend\ServiceManager\ServiceLocatorInterface
     */
    private $serviceLocator;

    /**
     * @param \Zend\ServiceManager\ServiceLocatorInterface $serviceLocator
     */
    public function setServiceLocator(ServiceLocatorInterface $serviceLocator)
    {
        $this->serviceLocator = $serviceLocator;
    }

    /**
     * @return \Zend\ServiceManager\ServiceLocatorInterface
     */
    public function getServiceLocator() {
        return $this->serviceLocator;
    }

}
