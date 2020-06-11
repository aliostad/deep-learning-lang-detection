<?php
namespace DkplusActionArguments\Service;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class ArgumentsServiceFactory implements FactoryInterface
{
    /**
     * @param ServiceLocatorInterface $serviceLocator
     * @return ArgumentsService
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        return new ArgumentsService(
            $serviceLocator->get('DkplusActionArguments\\Service\\MethodConfigurationProvider'),
            $serviceLocator
        );
    }
}
