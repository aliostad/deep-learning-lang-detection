<?php
namespace Collection\Controller;

use Zend\ServiceManager\ServiceLocatorInterface,
    Zend\ServiceManager\FactoryInterface;
use Collection\Service\CollectionService;
class ActiveCollectionControllerServiceFactory implements FactoryInterface
{
    /**
     * Create service
     *
     * @param ServiceLocatorInterface $serviceLocator
     * @return mixed
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        /** @var ServiceLocatorInterface $sl */
        $sl = $serviceLocator->getServiceLocator();

        /** @var CollectionService $service */
        $service = $sl->get('Collection\Service\Collection');

        /** @var ActiveCollectionController $controller */
        $controller = new ActiveCollectionController();
        $controller->setService($service);
        return $controller;
    }

} 