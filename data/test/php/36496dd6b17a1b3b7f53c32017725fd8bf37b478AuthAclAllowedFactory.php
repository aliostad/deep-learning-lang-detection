<?php
namespace CasasoftAuth\View\Helper;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

/**
 * Class CasaXmlServiceFactory
 *
 * @package CasaStation\View\Helper
 */
class AuthAclAllowedFactory implements FactoryInterface
{
    /**
     * Create service
     *
     * @param ServiceLocatorInterface $serviceLocator
     *
     * @return EventService
     */
    public function createService(ServiceLocatorInterface $viewHelperManager)
    {
        $serviceLocator = $viewHelperManager->getServiceLocator();
        $authService = $serviceLocator->get('CasasoftAuthService');
        
        $helper = new AuthAclAllowed($authService);
        
        return $helper;
    }
}