<?php

namespace WbBase\WbTrait\ServiceManager;

use Zend\ServiceManager\ServiceLocatorAwareInterface;

/**
 * ServiceManagerAwareTrait
 *
 * @package WbBase\WbTrait\ServiceManager
 * @author  Źmicier Hryškieivič <zmicier@webbison.com>
 */
trait ServiceLocatorAwareTrait
{
    /**
     * @var ServiceLocatorAwareInterface
     */
    protected $serviceLocator;

    /**
     * ServiceLocator setter
     * 
     * @param ServiceLocatorAwareInterface $serviceLocator Service locator. 
     * 
     * @return void
     */
    public function setServiceLocator(ServiceLocatorAwareInterface $serviceLocator)
    {
        $this->serviceLocator = $serviceLocator;
        return $this;
    }

    /**
     * ServiceLocator getter
     *
     * @return ServiceLocatorAwareInterface
     */
    public function getServiceLocator()
    {
        return $this->serviceLocator;
    }
}
