<?php
namespace Api\Controller\Factory;

use Api\Controller\AtividadeApiRestController;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class AtividadeApiRestControllerFactory implements FactoryInterface
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
        $service = $serviceLocator->get('api.service');
        return new AtividadeApiRestController($service);
    }
} 