<?php

namespace WebService\Factory;

use WebService\Service\ExtranetService;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class ExtranetServiceFactory implements FactoryInterface
{
    /**
     * Create service
     *
     * @param  ServiceLocatorInterface $services
     * @return ExtranetService
     */
    public function createService(ServiceLocatorInterface $services)
    {
        $entityManager = $services->get('Doctrine\ORM\EntityManager');

        return new ExtranetService($entityManager);
    }
}
