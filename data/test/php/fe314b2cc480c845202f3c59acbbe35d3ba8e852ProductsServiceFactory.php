<?php
/**
 * ERP System
 *
 * @author Tomasz Kuter <evolic_at_interia_dot_pl>
 * @copyright Copyright (c) 2013 Tomasz Kuter (http://www.tomaszkuter.com)
 */

namespace EvlErp\Factory\Service;

use EvlErp\Service\ProductsService;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

/**
 * Class ProductsServiceFactory - factory used to create ProductsService.
 *
 * @package EvlErp\Factory\Service
 */
class ProductsServiceFactory implements FactoryInterface
{
    /**
     * Factory method.
     *
     * @param ServiceLocatorInterface $serviceLocator
     * @return ProductsService|mixed
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $service = new ProductsService();
        $service->setEntityManager($serviceLocator->get('Doctrine\ORM\EntityManager'));

        return $service;
    }
}
