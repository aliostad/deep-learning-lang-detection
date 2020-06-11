<?php

namespace Ololz\Service\Factory;

use Zend\ServiceManager\ServiceLocatorInterface;
use Zend\ServiceManager\FactoryInterface;

/**
 * Search service factory
 *
 * @since   0.1
 * @author  Jérémy Huet <jeremy.huet+olol@gmail.com>
 * @link    https://github.com/olol/oLolZ
 * @package Ololz
 */
class ServiceSearch implements FactoryInterface
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
     * @return \Ololz\Service\Search\Base
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {

        /* @var $service \Ololz\Service\Persist\Base */
        $service = $serviceLocator->get('Ololz\Service\Persist\\'  . $this->serviceName);
        $serviceSearchClass = 'Ololz\Service\Search\\' . $this->serviceName;

        if (! class_exists($serviceSearchClass)) {
            throw new \InvalidArgumentException('The class ' . $serviceSearchClass . ' doest not exist and can not be created.');
        }

        /* @var $serviceSearch \Ololz\Service\Search\Base */
        $serviceSearch = new $serviceSearchClass();
        $serviceSearch->setService($service);
        $serviceSearch->setServiceManager($serviceLocator);

        $serviceSearch->init();

        return $serviceSearch;
    }
}
