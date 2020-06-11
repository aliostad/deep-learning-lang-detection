<?php
namespace Application\Controller;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use Zend\Stdlib\DispatchableInterface;

class SendefileControllerFactory implements FactoryInterface
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
        $controller = new SendefileController();
        $controller->setFileService($service);        
        $fighterService    = $sm->get('Application\Service\Fighter');
        $controller->setFighterService($fighterService);
        
        $fileUploadService    = $sm->get('FileUpload\Service\FileUpload');
        $controller->setFileUploadService($fileUploadService);
        return $controller;
    }
}
