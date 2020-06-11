<?php

namespace FzyCommon\Controller\Plugin;

use Zend\Mvc\Controller\Plugin\AbstractPlugin;
use Zend\ServiceManager\ServiceLocatorAwareInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

abstract class Base extends AbstractPlugin implements ServiceLocatorAwareInterface
{
    /**
     * @var \Zend\Mvc\Controller\PluginManager
     */
    protected $serviceLocator;

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
     * @return \Zend\Mvc\Controller\PluginManager
     */
    public function getServiceLocator()
    {
        return $this->serviceLocator;
    }

    protected function getService($key)
    {
        return $this->getServiceLocator()->getServiceLocator()->get($key);
    }
}
