<?php

namespace Core\Service;

use Zend\ServiceManager\ServiceManager;
use Zend\ServiceManager\ServiceManagerAwareInterface;
use Zend\ServiceManager\Exception\ServiceNotFoundException;

abstract class Service implements ServiceManagerAwareInterface {

    /**
     * @var ServiceManager
     */
    protected $serviceManager;

    /**
     * @var \Doctrine\ORM\EntityManager
     */
    protected $em;

    /**
     * @param ServiceManager $serviceManager
     */
    public function setServiceManager(ServiceManager $serviceManager) {
        $this->serviceManager = $serviceManager;
        //return $this;
    }

    /**
     * Retrieve serviceManager instance
     *
     * @return ServiceLocatorInterface
     */
    public function getServiceManager() {
        return $this->serviceManager;
    }

    /**
     * @return \Doctrine\ORM\EntityManager
     */
    public function getEm()
    {
        $this->em = $this->getServiceManager()->get('Doctrine\Orm\EntityManager');

        return $this->em;
    }
    
}
