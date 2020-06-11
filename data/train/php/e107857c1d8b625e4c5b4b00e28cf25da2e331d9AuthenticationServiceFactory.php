<?php
/**
 * 
 * User: Windows
 * Date: 1/19/14
 * Time: 1:54 PM
 * 
 */

namespace UserAuc\Service;


use UserAuc\Entity\AuthEntity;
use UserAuc\Service\AuthenticationService;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class AuthenticationServiceFactory implements FactoryInterface {
    /**
     * Create service
     *
     * @param ServiceLocatorInterface $serviceLocator
     * @return mixed
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $authService = new AuthenticationService();
        $sessionManager = $serviceLocator->get('Zend\Session\SessionManager');
        $authService->setUnderDev(true);
        $authService->setAuthEntity(new AuthEntity());
        $authService->setSessionManager($sessionManager);
        $authService->setDirService($serviceLocator->get('userDirManager'));
        return $authService;
    }


} 