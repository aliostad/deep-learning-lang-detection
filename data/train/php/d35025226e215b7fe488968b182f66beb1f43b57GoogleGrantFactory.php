<?php
namespace User\Factory\Grant;

use User\Grant\GoogleGrant;
use User\Service\UserService;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class GoogleGrantFactory implements FactoryInterface
{
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        /**
         * @var UserService                                      $userService
         * @var \Zend\ServiceManager\ServiceManager              $serviceManager
         * @var \ZfrOAuth2\Server\Service\TokenService           $accessTokenService
         * @var \ZfrOAuth2\Server\Service\TokenService           $refreshTokenService
         * @var \ZfrOAuth2Module\Server\Grant\GrantPluginManager $serviceLocator
         */
        $serviceManager      = $serviceLocator->getServiceLocator();
        $userService         = $serviceManager->get(UserService::class);
        $accessTokenService  = $serviceManager->get('ZfrOAuth2\Server\Service\AccessTokenService');
        $refreshTokenService = $serviceManager->get('ZfrOAuth2\Server\Service\RefreshTokenService');

        return new GoogleGrant($accessTokenService, $refreshTokenService, $userService);
    }
}
