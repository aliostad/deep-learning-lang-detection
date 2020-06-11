<?php
/**
 * ERP System
 *
 * @author Tomasz Kuter <evolic_at_interia_dot_pl>
 * @copyright Copyright (c) 2013 Tomasz Kuter (http://www.tomaszkuter.com)
 */

namespace EvlErp\Factory\Service;

use EvlErp\Service\ProductCategoriesService;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

/**
 * Class ProductCategoriesServiceFactory - factory used to create ProductCategoriesService.
 *
 * @package EvlErp\Factory\Service
 */
class ProductCategoriesServiceFactory implements FactoryInterface
{
    /**
     * Factory method.
     *
     * @param ServiceLocatorInterface $serviceLocator
     * @return ProductCategoriesService|mixed
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $service = new ProductCategoriesService();
        $service->setEntityManager($serviceLocator->get('Doctrine\ORM\EntityManager'));

        return $service;
    }
}
