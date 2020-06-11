<?php
/**
 * ERP System
 *
 * @author Tomasz Kuter <evolic_at_interia_dot_pl>
 * @copyright Copyright (c) 2013 Tomasz Kuter (http://www.tomaszkuter.com)
 */

namespace EvlErp\Factory\Service;

use EvlErp\Service\CompaniesService;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

/**
 * Class CompaniesServiceFactory - factory used to create CompaniesService.
 *
 * @package EvlErp\Factory\Service
 */
class CompaniesServiceFactory implements FactoryInterface
{
    /**
     * Factory method.
     *
     * @param ServiceLocatorInterface $serviceLocator
     * @return CompaniesService|mixed
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $service = new CompaniesService();
        $service->setEntityManager($serviceLocator->get('Doctrine\ORM\EntityManager'));

        return $service;
    }
}
