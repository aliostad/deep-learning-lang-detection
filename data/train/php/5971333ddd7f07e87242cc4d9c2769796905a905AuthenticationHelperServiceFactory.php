<?php
namespace Authentication\View\Helper;

use Zend\ServiceManager\ServiceLocatorInterface,
    Zend\ServiceManager\FactoryInterface;
use Authentication\Service\AuthenticationService;
class AuthenticationHelperServiceFactory implements FactoryInterface
{
    /**
     * Create service
     *
     * @param ServiceLocatorInterface $serviceLocator
     * @return AuthenticationHelper
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $sl = $serviceLocator->getServiceLocator();

        /** @var AuthenticationService $service */
        $service = $sl->get('Authentication\Service\Authentication');

        /** @var AuthenticationHelper $helper */
        $helper = new AuthenticationHelper($service);
        return $helper;
    }

} 