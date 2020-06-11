<?php
/**
 * Class ApiServiceFactory
 */
namespace Api\Service\Factory;

use Api\Service\ApiService;
use Doctrine\Common\Persistence\ObjectManager;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class ApiServiceFactory implements FactoryInterface
{
    /**
     * Create service
     *
     * @param ServiceLocatorInterface $serviceLocator
     * @return mixed
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        /** @var ObjectManager $objectManager */
        $objectManager = $serviceLocator->get('Doctrine\ORM\EntityManager');
        return new ApiService($objectManager);
    }
} 