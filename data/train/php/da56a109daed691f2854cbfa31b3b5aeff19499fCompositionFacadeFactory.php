<?php

namespace BzlMail\Service;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use BzlMail\Composition\Facade;
/**
 * Description of CompositionFacadeFactory
 *
 * @author Bezalel
 */
class CompositionFacadeFactory implements FactoryInterface {

    public function createService(ServiceLocatorInterface $services)
    {
        $config = $services->get('BzlMail\Config');
        
        $facade = new Facade();
        $facade->setServiceLocator($services);
        $facade->setDefaultSender(
                $config['composition_facade']['sender_email'], 
                $config['composition_facade']['sender_name']
            );
        $facade->setTransport($config['composition_facade']['transport']);
        
        return $facade;
    }
}
