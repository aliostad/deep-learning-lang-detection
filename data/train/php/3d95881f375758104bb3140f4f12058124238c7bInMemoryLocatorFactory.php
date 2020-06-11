<?php
/**
 * Created by Gary Hockin.
 * Date: 12/01/15
 * @GeeH
 */

namespace TacticianModule\Factory;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class InMemoryLocatorFactory implements FactoryInterface
{

    /**
     * Create service
     *
     * @param ServiceLocatorInterface $serviceLocator
     * @return mixed
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $config  = $serviceLocator->get('config')['tactician'];
        $locator = new $config['default-locator']();
        foreach ($config['commandbus-handlers'] as $command => $handler) {
            $locator->addHandler($serviceLocator->get($handler), $command);
        }
        return $locator;
    }
}
