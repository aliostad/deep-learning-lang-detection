<?php
namespace Ipmpdf\Controller;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use Zend\Stdlib\DispatchableInterface;


/**
 * Description of IndexControllerFactory
 *
 * @author aqnguyen
 */
class IndexControllerFactory implements FactoryInterface
{
    /**
     * Create Service Factory
     * 
     * @param ServiceLocatorInterface $serviceLocator
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $sm         = $serviceLocator->getServiceLocator();
        $service    = $sm->get('Ipmpdf\Service\Ipmpdf');
        $controller = new IndexController();
        $controller->setIpmpdfService($service);
        return $controller;
    }
}
