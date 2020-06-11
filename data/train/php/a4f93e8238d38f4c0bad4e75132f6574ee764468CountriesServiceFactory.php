<?php
/**
 * ERP System
 *
 * @author Tomasz Kuter <evolic_at_interia_dot_pl>
 * @copyright Copyright (c) 2013 Tomasz Kuter (http://www.tomaszkuter.com)
 */

namespace EvlErp\Factory\Service;

use EvlErp\Service\CountriesService;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

/**
 * Class CountriesServiceFactory - factory used to create CountriesService.
 *
 * @package EvlErp\Factory\Service
 */
class CountriesServiceFactory implements FactoryInterface
{
    /**
     * Factory method.
     *
     * @param ServiceLocatorInterface $serviceLocator
     * @return CountriesService|mixed
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $service = new CountriesService();
        $service->setEntityManager($serviceLocator->get('Doctrine\ORM\EntityManager'));

        return $service;
    }
}
