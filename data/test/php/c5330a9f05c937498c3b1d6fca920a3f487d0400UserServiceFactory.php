<?php

/**
 * namespace definition and usage
 */
namespace User\Service;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

/**
 * Create user service factory
 * 
 * @package    User
 */
class UserServiceFactory implements FactoryInterface
{
    /**
     * Create Service Factory
     * 
     * @param ServiceLocatorInterface $serviceLocator
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $table   = $serviceLocator->get('User\Table\User');
        $auth    = $serviceLocator->get('User\Auth\Service');
        $service = new UserService($table, $auth);
        return $service;
    }
}
