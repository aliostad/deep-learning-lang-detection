<?php

namespace Util\Form\Base;

use Zend\Form\Form;
use Zend\ServiceManager\ServiceLocatorAwareInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

abstract class AbstractForm extends Form implements ServiceLocatorAwareInterface
{
    protected $_sl;
    
    public function __construct(ServiceLocatorInterface $serviceLocator)
    {
        parent::__construct();        
        $this->setServiceLocator($serviceLocator);        
    }
        
    /**
     * Get service locator
     *
     * @return \Zend\ServiceManager\ServiceLocatorInterface;
     */
    public function getServiceLocator()
    {
        return $this->_sl;
    }
    
    /**
     * Set service locator
     *
     * @param ServiceLocatorInterface $serviceLocator
     */
    public function setServiceLocator(ServiceLocatorInterface $serviceLocator)
    {
        $this->_sl = $serviceLocator;
    }
}