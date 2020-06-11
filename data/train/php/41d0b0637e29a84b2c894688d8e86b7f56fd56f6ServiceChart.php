<?php

namespace Ololz\Service\Factory;

use Zend\ServiceManager\ServiceLocatorInterface;
use Zend\ServiceManager\FactoryInterface;

/**
 * Chart service factory
 *
 * @since   0.1
 * @author  Jérémy Huet <jeremy.huet+olol@gmail.com>
 * @link    https://github.com/olol/oLolZ
 * @package Ololz
 */
class ServiceChart implements FactoryInterface
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
        /* @var $mapper \Ololz\Mapper\Base */
        $mapper = $serviceLocator->get('Ololz\Mapper\\'  . $this->serviceName);
        $serviceChartClass = 'Ololz\Service\Chart\\' . $this->serviceName;

        if (! class_exists($serviceChartClass)) {
            throw new \InvalidArgumentException('The class ' . $serviceChartClass . ' doest not exist and can not be created.');
        }

        /* @var $serviceChart \Ololz\Service\Chart\Base */
        $serviceChart = new $serviceChartClass();
        $serviceChart->setMapper($mapper);
        $serviceChart->setServiceManager($serviceLocator);

        $serviceChart->init();

        return $serviceChart;
    }
}
