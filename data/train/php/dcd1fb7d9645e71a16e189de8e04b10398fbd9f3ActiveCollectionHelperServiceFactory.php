<?php
namespace Collection\View\Helper;

use Zend\ServiceManager\FactoryInterface,
    Zend\ServiceManager\ServiceLocatorInterface;
use Collection\Service\CollectionService;

class ActiveCollectionHelperServiceFactory implements FactoryInterface
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

        return new ActiveCollectionHelper($service);
    }

} 