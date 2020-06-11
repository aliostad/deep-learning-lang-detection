<?php
namespace DkplusActionArguments\Service;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class ZfcRbacServiceDecoratorFactory implements FactoryInterface
{
    /**
     * @param ServiceLocatorInterface $serviceLocator
     * @return ZfcRbacServiceDecorator
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $rbacService = $serviceLocator->get('ZfcRbac\\Service\\AuthorizationService');
        return new ZfcRbacServiceDecorator($rbacService);
    }
}
