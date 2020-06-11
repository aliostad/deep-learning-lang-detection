<?php

namespace ModelFramework\BaseService;

use Zend\ServiceManager\ServiceLocatorInterface;

trait ServiceLocatorAwareTrait
{
    /**
     * @var ServiceLocatorInterface
     */
    private $_services = null;

    /**
     * @param ServiceLocatorInterface $serviceLocator
     *
     * @return $this
     */
    public function setServiceLocator(ServiceLocatorInterface $serviceLocator)
    {
        $this->_services = $serviceLocator;

        return $this;
    }

    /**
     * @return ServiceLocatorInterface
     */
    public function getServiceLocator()
    {
        return $this->_services;
    }

    /**
     * @return ServiceLocatorInterface
     *
     * @throws \Exception
     */
    public function getServiceLocatorVerify()
    {
        $_services = $this->getServiceLocator();
        if ($_services == null || !$_services instanceof ServiceLocatorInterface) {
            throw new \Exception('ServiceLocator does not set in the ServiceLocatorAware service '.get_class($this));
        }

        return $_services;
    }
}
