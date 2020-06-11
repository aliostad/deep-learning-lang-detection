<?php
/**
 * Created by PhpStorm.
 * User: tobre
 * Date: 14.04.14
 * Time: 14:20
 */

namespace BitWeb\ErrorReportingModule\Service\Factory;


use BitWeb\ErrorReporting\Service\ErrorService;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class ErrorServiceFactory implements FactoryInterface {

    /**
     * Create service
     *
     * @param ServiceLocatorInterface $serviceLocator
     * @return mixed
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $service = new ErrorService($serviceLocator->get('Config')['error_reporting']);

        return $service;
    }

}