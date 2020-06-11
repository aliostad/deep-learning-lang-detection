<?php
namespace AppApi\Controller;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use Zend\Stdlib\DispatchableInterface;


/**
 * Description of IndexControllerFactory
 *
 * @author aqnguyen
 */
class L10nControllerFactory implements FactoryInterface
{
    /**
     * Create Service Factory
     * 
     * @param ServiceLocatorInterface $serviceLocator
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $sm         = $serviceLocator->getServiceLocator();
        $service    = $sm->get('AppApi\Service\L10n');
        $controller = new L10nController();
        $controller->setTranslateService($service);
        return $controller;
    }
}