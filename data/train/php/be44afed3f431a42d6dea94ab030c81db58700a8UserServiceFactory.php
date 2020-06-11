<?php
namespace Application\factory;

use Doctrine\ORM\EntityManager;
use Zend\ServiceManager\ServiceLocatorInterface;
use Zend\ServiceManager\FactoryInterface;
use Application\Service\UserService;

/**
 * Class UserServiceFactory
 */
class UserServiceFactory implements FactoryInterface
{
    /**
     * @param ServiceLocatorInterface $serviceLocator
     * @return UserService
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $service = new UserService();
        /** @var EntityManager $em */
        $em = $serviceLocator->get(EntityManager::class);
        $service->setEntityManager($em);

        return $service;
    }
}
