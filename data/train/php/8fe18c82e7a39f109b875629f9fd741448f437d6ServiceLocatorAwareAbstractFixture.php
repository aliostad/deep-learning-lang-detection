<?php

namespace EwgoDoctrineFixtures\Fixture;

use Doctrine\Common\DataFixtures\AbstractFixture;
use Zend\ServiceManager\ServiceLocatorAwareInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

/**
 * Convenience class for ServiceLocator aware fixtures
 *
 * @package EwgoDoctrineFixtures\Fixture
 */
abstract class ServiceLocatorAwareAbstractFixture extends AbstractFixture implements ServiceLocatorAwareInterface
{
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
     * @return ServiceLocatorInterface
     */
    public function getServiceLocator()
    {
        return $this->serviceLocator;
    }
}
