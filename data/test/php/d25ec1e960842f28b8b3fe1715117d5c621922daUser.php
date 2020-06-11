<?php

namespace DmMailerCli\Factory\Controller;

use Zend\Log\Logger;
use Zend\Mvc\Controller\ControllerManager;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

use ZfcUser\Service\User as UserService;

use DmMailerCli\Controller\UserController;

class User implements FactoryInterface
{
    /**
     * @param ServiceLocatorInterface $serviceLocator
     *
     * @return UserController
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        if ($serviceLocator instanceof ControllerManager) {
            $serviceLocator = $serviceLocator->getServiceLocator();
        }

        /** @var Logger $logger */
        $logger = $serviceLocator->get('DmMailer\Log');

        /** @var UserService $userService */
        $userService = $serviceLocator->get('zfcuser_user_service');

        $controller = new UserController($userService, $logger);

        return $controller;
    }
}
