<?php
namespace Magazines\Controller;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class IndexControllerFactory implements FactoryInterface
{
    public function createService(ServiceLocatorInterface $controllerManager)
    {
        $serviceLocator = $controllerManager->getServiceLocator();
        $magazineService = $serviceLocator->get('Magazines\Service\MagazineService');
        $controller = new IndexController();
        $controller->setMagazineService($magazineService);
        return $controller;
    }
}
