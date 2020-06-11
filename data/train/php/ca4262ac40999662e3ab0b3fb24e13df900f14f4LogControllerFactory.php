<?php

namespace Logged\Controller;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class LogControllerFactory implements FactoryInterface
{
    /**
     * Create LogController.
     *
     * @param ServiceLocatorInterface $serviceLocator
     *
     * @return LogController
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $scopedServiceLocator = $serviceLocator->getServiceLocator();
        $sysLogService = $scopedServiceLocator->get('Logged\Service\SysLogService');

        $logController = new LogController($sysLogService);

        return $logController;
    }
}
