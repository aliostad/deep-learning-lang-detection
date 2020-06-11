<?php
namespace Collection\Controller;

use Zend\ServiceManager\ServiceLocatorInterface,
    Zend\ServiceManager\FactoryInterface;
use Collection\Table\CollectionTable,
    Collection\Service\CollectionService,
    Authentication\Service\AuthenticationService;
class CollectionControllerServiceFactory implements FactoryInterface
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

        /** @var CollectionTable $table */
        $table = $sl->get('Collection\Table\Collection');

        /** @var CollectionService $service */
        $service = $sl->get('Collection\Service\Collection');

        /** @var AuthenticationService $authService */
        $authService = $sl->get('Authentication\Service\Authentication');

        /** @var CollectionController $controller */
        $controller = new CollectionController();
        $controller->setCollectionTable($table);
        $controller->setAuthService($authService);
        $controller->setCollectionService($service);
        return $controller;
    }

} 