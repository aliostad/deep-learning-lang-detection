<?php
/**
 * Created by PhpStorm.
 * User: nikolajus
 * Date: 10/25/13
 * Time: 2:03 PM
 */

namespace Prison\Service;

use Zend\ServiceManager\ServiceLocatorAwareInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class ServiceAbstract implements ServiceLocatorAwareInterface
{
    /** @var ServiceLocatorInterface */
    protected $service;

    public function __construct(ServiceLocatorInterface $service)
    {
        $this->setServiceLocator($service);
    }

    /**
     * Set service locator
     *
     * @param ServiceLocatorInterface $serviceLocator
     */
    public function setServiceLocator(ServiceLocatorInterface $serviceLocator)
    {
        $this->service = $serviceLocator;
    }

    /**
     * Get service locator
     *
     * @return ServiceLocatorInterface
     */
    public function getServiceLocator()
    {
        return $this->service;
    }

} 