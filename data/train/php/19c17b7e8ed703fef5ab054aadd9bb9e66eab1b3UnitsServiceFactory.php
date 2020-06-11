<?php
/**
 * ERP System
 *
 * @author Tomasz Kuter <evolic_at_interia_dot_pl>
 * @copyright Copyright (c) 2013 Tomasz Kuter (http://www.tomaszkuter.com)
 */

namespace EvlErp\Factory\Service;

use EvlErp\Service\UnitsService;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

/**
 * Class UnitsServiceFactory - factory used to create UnitsService.
 *
 * @package EvlErp\Factory\Service
 */
class UnitsServiceFactory implements FactoryInterface
{
    /**
     * Factory method.
     *
     * @param ServiceLocatorInterface $serviceLocator
     * @return UnitsService|mixed
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $service = new UnitsService();
        $service->setEntityManager($serviceLocator->get('Doctrine\ORM\EntityManager'));

        return $service;
    }
}
