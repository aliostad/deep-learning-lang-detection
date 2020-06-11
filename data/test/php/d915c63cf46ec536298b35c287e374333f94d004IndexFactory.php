<?php
namespace Application\Factory\Controller;

use Application\Controller\IndexController;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class IndexFactory implements FactoryInterface
{
    /**
     * Create service
     *
     * @param ServiceLocatorInterface $serviceLocator
     * @return mixed
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $serviceLocator = $serviceLocator->getServiceLocator();
        return new IndexController(
            $serviceLocator->get('Zend\Authentication\AuthenticationService'),
            $serviceLocator->get('Application\Service\Orchestrate\StorageService'),
            $serviceLocator->get('CloudConvert\Api')
         );
    }
}