<?php
namespace User\Service;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class UserServiceFactory implements FactoryInterface
{
    /**
     *
     * @param ServiceLocatorInterface $serviceLocator
     * @return User
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $tick = $serviceLocator->get('Core\Service\Tick');

        $tables['user'] = $serviceLocator->get('User\Table\UserTable');

        $service   = new UserService($tick, $tables);
        return $service;
    }
}