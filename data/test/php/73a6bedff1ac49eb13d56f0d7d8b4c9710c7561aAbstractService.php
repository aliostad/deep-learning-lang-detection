<?php
namespace SchwarzesSachsenCore\Service;

use Zend\ServiceManager\ServiceManager;
use Zend\ServiceManager\ServiceManagerAwareInterface;

/**
 * Service Abstract
 *
 * This base class contains common functions for service classes
 *
 * @copyright Copyright (c) 2012 Unister GmbH
 */
abstract class AbstractService implements ServiceManagerAwareInterface
{
    /**
     * Service Manager
     *
     * @var ServiceManager
     */
    protected $_serviceManager;

    /**
     * Set service locator to retrieve other services
     *
     * @param \Zend\ServiceManager\ServiceLocatorInterface $serviceLocator Service locator
     * @return AbstractService
     */
    public function setServiceManager(ServiceManager $serviceManager)
    {
        $this->_serviceManager = $serviceManager;
        return $this;
    }

    /**
     * Get service locator to retrieve other services
     *
     * @return ServiceManager
     */
    public function getServiceManager()
    {
        return $this->_serviceManager;
    }
}