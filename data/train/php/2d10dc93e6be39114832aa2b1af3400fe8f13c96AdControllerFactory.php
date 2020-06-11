<?php

namespace Admin\Controller\Factory;

use Admin\Controller\AdController;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class AdControllerFactory implements FactoryInterface {

    public function createService(ServiceLocatorInterface $serviceLocator) {
        $realServiceLocator = $serviceLocator->getServiceLocator();
        $commonService = $realServiceLocator->get('Common\Service\CommonServiceInterface');
        $adminService = $realServiceLocator->get('Admin\Service\AdminServiceInterface');
        $adService = $realServiceLocator->get('Admin\Service\AdServiceInterface');

        return new NewsController($commonService, $adminService, $adService);
    }

}
