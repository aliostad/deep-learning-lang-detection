<?php
namespace INNN\Service;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class EventServiceFactory implements FactoryInterface
{
    /**
     *
     * @param ServiceLocatorInterface $serviceLocator
     * @return EventService
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $tick = $serviceLocator->get('Core\Service\Tick');
        $tables['event'] = $serviceLocator->get('INNN\Table\EventTable');
        return new EventService($tick, $tables);
    }
}