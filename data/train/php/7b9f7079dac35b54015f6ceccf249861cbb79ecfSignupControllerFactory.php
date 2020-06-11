<?php
/**
 * Created by PhpStorm.
 * User: Jfranco
 * Date: 3/22/2015
 * Time: 12:04 AM
 */

namespace Authenticate\Factory;

use Authenticate\Controller\SignupController;
use Authenticate\View\SignupView;
use User\UserService;
use Zend\ServiceManager\Exception\ServiceNotCreatedException;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorAwareInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

/**
 * Class SignupControllerFactory
 * @package Authenticate\Factory
 */
class SignupControllerFactory implements FactoryInterface
{
    /**
     * @param ServiceLocatorInterface $service
     * @return SignupController
     * @throws ServiceNotCreatedException
     */
    public function createService(ServiceLocatorInterface $service)
    {
        $service = $service instanceof ServiceLocatorAwareInterface
            ? $service->getServiceLocator()
            : $service;

        return new SignupController(
            $this->getSignupView($service),
            $this->getUserService($service)
        );
    }

    /**
     * @param ServiceLocatorInterface $service
     * @return SignupView
     */
    protected function getSignupView(ServiceLocatorInterface $service)
    {
        if (!$service->has('Authenticate\View\Signup')) {
            throw new ServiceNotCreatedException('Cannot create SignupController missing SignupView');
        }

        $signupView = $service->get('Authenticate\View\Signup');

        if (!$signupView instanceof SignupView) {
            throw new ServiceNotCreatedException('Cannot create SignupController invalid SignupView');
        }

        return $signupView;
    }

    /**
     * @param ServiceLocatorInterface $service
     * @return UserService
     */
    protected function getUserService(ServiceLocatorInterface $service)
    {
        if (!$service->has('UserService')) {
            throw new ServiceNotCreatedException('Cannot create SignupForm missing UserService');
        }

        $userService = $service->get('UserService');

        if (!$userService instanceof UserService) {
            throw new ServiceNotCreatedException('Cannot create SignupForm invalid UserService');
        }

        return $userService;
    }
}
