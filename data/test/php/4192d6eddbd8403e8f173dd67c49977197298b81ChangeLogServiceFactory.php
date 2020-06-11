<?php
namespace Application\Service;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;


/**
 * Description of ChangeLog
 *
 * @author aqnguyen
 */
class ChangeLogServiceFactory implements FactoryInterface
{
    /**
     * Create Service Factory
     * 
     * @param ServiceLocatorInterface $serviceLocator
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $db   = $serviceLocator->get('doctrine.entitymanager.orm_default');
        $service = new ChangeLogService($db);
        return $service;
    }
}
