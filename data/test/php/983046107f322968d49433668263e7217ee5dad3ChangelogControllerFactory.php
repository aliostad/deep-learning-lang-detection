<?php
namespace Application\Controller;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use Zend\Stdlib\DispatchableInterface;


/**
 * Description of IndexControllerFactory
 *
 * @author aqnguyen
 */
class ChangelogControllerFactory implements FactoryInterface
{
    /**
     * Create Service Factory
     * 
     * @param ServiceLocatorInterface $serviceLocator
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $sm         = $serviceLocator->getServiceLocator();
        $service    = $sm->get('Application\Service\ChangeLog');
        $controller = new ChangelogController();
        $controller->setChangeLogService($service);
        return $controller;
    }
}
