<?php
namespace WebReattivoCore\Factory\Service;

use WebReattivoCore\Service\UserService;
use WebReattivoCore\Service\UserTokenService;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

/**
 * Class UserTokenFactory
 * @package WebReattivoCore\Factory\Service
 */
class UserTokenFactory implements FactoryInterface
{
    /**
     * @param ServiceLocatorInterface $serviceLocator
     *
     * @return UserTokenService
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        return new UserTokenService();
    }
}