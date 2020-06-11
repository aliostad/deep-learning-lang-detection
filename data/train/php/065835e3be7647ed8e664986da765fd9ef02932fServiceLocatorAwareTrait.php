<?php

namespace Protec\ZF2Trait\ServiceManager;

use \Zend\ServiceManager\ServiceLocatorInterface;

/**
 * ServiceLocatorAwareTrait
 *
 * @package   Protec\ZF2Trait\ServiceManager
 * @author    Protec Innovations <support@protecinnovations.co.uk>
 * @copyright 2012 Protec Innovations
 */
trait ServiceLocatorAwareTrait
{
    /**
     * @var \Zend\ServiceManager\ServiceLocator
     */
    protected $service_locator = null;

    /**
     * setServiceLocator
     *
     * @param \Zend\ServiceManager\ServiceLocatorInterface $serviceLocator
     * @return
     */
    public function setServiceLocator(ServiceLocatorInterface $serviceLocator)
    {
        $this->service_locator = $serviceLocator;

        return $this;
    }

    /**
     * getServiceLocator
     *
     * @return \Zend\ServiceManager\ServiceLocator
     */
    public function getServiceLocator()
    {
        return $this->service_locator;
    }
}
