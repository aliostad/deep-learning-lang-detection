<?php
namespace AppApi\Controller;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use Zend\Stdlib\DispatchableInterface;


/**
 * Description of IndexControllerFactory
 *
 * @author aqnguyen
 */
class FileControllerFactory implements FactoryInterface
{
    /**
     * Create Service Factory
     * 
     * @param ServiceLocatorInterface $serviceLocator
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $sm         = $serviceLocator->getServiceLocator();
        $service    = $sm->get('Application\Service\File');
        $controller = new FileController();
        $controller->setFileService($service);
        return $controller;
    }
}