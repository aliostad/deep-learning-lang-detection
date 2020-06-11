<?php
namespace Authorization\View\Helper;

use Zend\ServiceManager\FactoryInterface,
    Zend\ServiceManager\ServiceLocatorInterface;
use Authorization\Service\AuthorizationService;
class HasAccessServiceFactory implements FactoryInterface
{
    /**
     * Create service
     *
     * @param ServiceLocatorInterface $serviceLocator
     * @return HasAccess
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        /** @var ServiceLocatorInterface $sl */
        $sl = $serviceLocator->getServiceLocator();

        /** @var AuthorizationService $service */
        $service = $sl->get('Authorization\Service\Authorization');

        return new HasAccess($service);
    }

} 