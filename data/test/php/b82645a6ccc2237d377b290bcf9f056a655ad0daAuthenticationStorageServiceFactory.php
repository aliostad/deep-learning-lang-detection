<?php
/**
 * Created by PhpStorm.
 * User: Naman
 * Date: 11/03/2015
 * Time: 16:27
 */

namespace User\Service\Factory;

use User\Service\AuthenticationStorageService;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class AuthenticationStorageServiceFactory implements FactoryInterface
{

    /**
     * Create service
     *
     * @param ServiceLocatorInterface $serviceLocator
     * @return mixed
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $config = $serviceLocator->get('config');
        $appName = $config['application']['name'];

        return new AuthenticationStorageService($appName);
    }
}