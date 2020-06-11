<?php
namespace User\Service;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use User\Service\UserService;

class UserServiceFactory implements FactoryInterface
{
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
         $userTable = $serviceLocator->get('User\Model\Dbtables\User'); 
         $auth    = $serviceLocator->get('User\Auth\AuthService');
         $form = $serviceLocator->get('User\Forms\Login');
         $service = new UserService();
         $service->setForm($form);
         $service->setUserTable($userTable);
         $service->setAuthentication($auth);
         
         return $service;
    }
}