<?php

/**
 * namespace definition and usage
 */
namespace User\Authentication;

use Zend\Authentication\AuthenticationService;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

/**
 * User authentication service factory
 * 
 * Generates the user authentication service object
 * 
 * @package    User
 */
class ServiceFactory implements FactoryInterface
{
    /**
     * Create Service Factory
     * 
     * @param ServiceLocatorInterface $serviceLocator
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $authAdapter = $serviceLocator->get('User\Auth\Adapter');
        
        $auth = new AuthenticationService();
        $auth->setAdapter($authAdapter);
        return $auth;
    }
}
