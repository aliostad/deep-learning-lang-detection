<?php

namespace RvBase\ServiceProvider;

use RvBase\Permissions\PermissionsInterface;
use Zend\ServiceManager\Exception;
use Zend\ServiceManager\ServiceLocatorAwareInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

/**
 * Класс PermissionsServiceProviderTrait
 * @package RvBase\ServiceProvider
 */
trait PermissionsServiceProviderTrait
{
    /**
     * @return PermissionsInterface
     */
    protected function getPermissionsService(ServiceLocatorInterface $serviceLocator)
    {
        if ($serviceLocator instanceof ServiceLocatorAwareInterface) {
            $serviceLocator = $serviceLocator->getServiceLocator();
        }

        $permissionsConfig = $serviceLocator->get('Config')['rv-base']['permissions'];
        if (empty($permissionsConfig['service'])) {
            throw new Exception\ServiceNotFoundException(
                'Name for permissions service not set'
            );
        }
        $serviceName = $permissionsConfig['service'];

        return $serviceLocator->get(
            $serviceName
        );
    }
}
