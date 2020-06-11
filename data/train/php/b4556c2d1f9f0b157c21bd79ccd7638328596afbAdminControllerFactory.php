<?php
namespace Forum\Factory;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use Forum\Controller\AdminController;
class AdminControllerFactory implements FactoryInterface
{
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $realServiceLocator = $serviceLocator->getServiceLocator();
        $recruitService        = $realServiceLocator->get('Forum\Service\AdminServiceInterface');
        
        return new AdminController($recruitService);
    }
}

?>