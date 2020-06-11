<?php
namespace BqUser\Service;

use Zend\Authentication\AuthenticationService as ZendAuthService;
use BqCore\Service\ServiceInterface;

class Auth extends ZendAuthService implements ServiceInterface
{
    protected $serviceLocator;

    public function getUser() {
        if($this->hasIdentity()) {
            $userService = $this->getServiceLocator()->get('BqUser\User');
            $user = $userService->getEntities(array($this->getIdentity()))
                ->current();
            return $user;
        }

        return null;
    }

    public function createService(ServiceLocatorInterface $serviceLocator) {
        $this->setServiceLocator($serviceLocator);
        return $this;
    }

    public function getServiceLocator() {
        return $this->serviceLocator;
    }

    public function setServiceLocator(ServiceLocatorInterface $serviceLocator) {
        $this->serviceLocator = $serviceLocator;
        return $this;
    }

}
