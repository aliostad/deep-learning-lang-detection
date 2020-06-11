<?php

namespace Ololz\Service\Factory;

use Zend\ServiceManager\ServiceLocatorInterface;
use Zend\ServiceManager\FactoryInterface;

/**
 * Persist service factory
 *
 * @since   0.1
 * @author  Jérémy Huet <jeremy.huet+olol@gmail.com>
 * @link    https://github.com/olol/oLolZ
 * @package Ololz
 */
class ServicePersist implements FactoryInterface
{
    protected $serviceName;

    /**
     * @param string $serviceName
     */
    public function __construct($serviceName)
    {
        $this->serviceName = ucfirst($serviceName);
    }

    /**
     * {@inheritDoc}
     *
     * @return \Ololz\Service\Persist\Base
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        /* @var $mapper \Ololz\Mapper\Base */
        $mapper = $serviceLocator->get('Ololz\Mapper\\'  . $this->serviceName);
        $servicePersistClass = 'Ololz\Service\Persist\\' . $this->serviceName;

        if (! class_exists($servicePersistClass)) {
            throw new \InvalidArgumentException('The class ' . $servicePersistClass . ' doest not exist and can not be created.');
        }

        /* @var $servicePersist \Ololz\Service\Persist\Base */
        $servicePersist = new $servicePersistClass();
        $servicePersist->setMapper($mapper);
        $servicePersist->setServiceManager($serviceLocator);

        $servicePersist->init();

        return $servicePersist;
    }
}
