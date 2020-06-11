<?php

namespace Application\Login\Factory;

use Zend\ServiceManager\FactoryInterface;
use Application\Login\Service\LoginInfoService;
use Zend\ServiceManager\ServiceLocatorInterface;

/**
 * ログイン情報サービスファクトリーのクラス
 */
class LoginInfoServiceFactory implements FactoryInterface
{
    /**
     * ログイン情報サービスの作成
     * @param ServiceLocatorInterface $serviceLocator
     * @return LoginInfoService
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        return new LoginInfoService($serviceLocator);
    }
}
