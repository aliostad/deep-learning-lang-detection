<?php

namespace Recipes\Service\Factory;

use Recipes\Service\UserService;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class UserServiceFactory implements FactoryInterface
{
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $entityManager = $serviceLocator->get('Doctrine\ORM\EntityManager');
        $repository = $entityManager->getRepository('\Recipes\Entity\User');

        return new UserService($entityManager, $repository);
    }
}