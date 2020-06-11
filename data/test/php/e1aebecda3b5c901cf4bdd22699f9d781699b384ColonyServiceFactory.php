<?php
namespace Colony\Service;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class ColonyServiceFactory implements FactoryInterface
{
    /**
     *
     * @param ServiceLocatorInterface $serviceLocator
     * @return
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $tick   = $serviceLocator->get('Core\Service\Tick');
        $logger = $serviceLocator->get('logger');

        $tables = array();
        $tables['colony'] = $serviceLocator->get('Colony\Table\ColonyTable');

        $gateway = new ColonyService($tick, $tables, array(), array());
        $gateway->setLogger($logger);
        return $gateway;
    }
}