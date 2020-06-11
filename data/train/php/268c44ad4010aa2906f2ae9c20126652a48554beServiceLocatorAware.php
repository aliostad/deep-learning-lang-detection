<?php
 
namespace Common\Model;

use Zend\ServiceManager\ServiceLocatorAwareInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class ServiceLocatorAware implements ServiceLocatorAwareInterface {
    
    /**
     *  Zend service locator singleton 
     *  @var    Zend\ServiceLocator\ServiceLocator
     */
    private static $serviceLocator = null;

    
    public function setServiceLocator( ServiceLocatorInterface $serviceLocator )
    {
        if ( get_class( $serviceLocator ) !== 'Zend\ServiceManager\ServiceManager' )
            throw new \Exception( 'ServiceLocatorAware->setServiceLocator called' .
                                  ' outside of ServiceManager context in ' .
                                  get_class( $serviceLocator ) . ' instead' );                
        self::$serviceLocator = $serviceLocator;
    }

    public function getServiceLocator()
    {
        if ( self::$serviceLocator === null )
            throw new \Exception( 'ServiceLocatorAware not initialised' );
        
        return self::$serviceLocator;
    }
}
