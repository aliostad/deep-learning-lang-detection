<?php

namespace JhFlexiTime\Service\Factory;

use JhFlexiTime\Service\PeriodService;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

/**
 * Class PeriodServiceFactory
 * @package JhFlexiTime\Service\Factory
 * @author Aydin Hassan <aydin@wearejh.com>
 */
class PeriodServiceFactory implements FactoryInterface
{
    /**
     * @param ServiceLocatorInterface $serviceLocator
     * @return PeriodService
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        return new PeriodService(
            $serviceLocator->get('FlexiOptions')
        );
    }
}
