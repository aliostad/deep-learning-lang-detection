<?php
namespace ApiConsumer\Factory;

use ApiConsumer\Service\ApiMetaDataService;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use Zend\Stdlib\Hydrator\ClassMethods;

class ApiMetadataServiceFactory implements FactoryInterface
{
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $config = $serviceLocator->get('Config');
        $metadataService = $serviceLocator->get('MetadataService');
        $hydrator = new ClassMethods(false);

        return new ApiMetaDataService($config, $metadataService, $hydrator);
    }
} 