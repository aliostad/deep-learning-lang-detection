<?php

namespace Application\Login\Factory;

use Zend\ServiceManager\FactoryInterface;
use Application\Login\Service\LoginService;
use Zend\ServiceManager\ServiceLocatorInterface;

/**
 * ログインサービスファクトリーのクラス
 */
class LoginServiceFactory implements FactoryInterface
{
    /**
     * ログインサービスの作成
     * @param ServiceLocatorInterface $serviceLocator
     * @return LoginService
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        return new LoginService($serviceLocator);
    }
}
