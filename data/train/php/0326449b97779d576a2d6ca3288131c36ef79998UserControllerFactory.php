<?php
namespace Acelaya\Controller;

use Acelaya\Service\UserService;
use Slim\Slim;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

/**
 * Class UserControllerFactory
 * @author
 * @link
 */
class UserControllerFactory implements FactoryInterface
{
    /**
     * Create service
     *
     * @param ServiceLocatorInterface $serviceLocator
     * @return mixed
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        /** @var UserService $userService */
        $userService = $serviceLocator->get(UserService::class);
        return new UserController($userService);
    }
}
