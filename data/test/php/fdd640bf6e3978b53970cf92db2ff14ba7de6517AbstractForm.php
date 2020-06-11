<?php

namespace TakeATea\Form;

use Zend\Form\Form;
use Zend\ServiceManager\ServiceLocatorAwareInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class AbstractForm extends Form implements ServiceLocatorAwareInterface
{
    protected $serviceLocator;
    
    public function __construct($name = null, $options = array()) {
        parent::__construct($name, $options);
        
        $token = new \Zend\Form\Element\Csrf('token');
        $this->add($token);
    }
    
    /**
     * Set service locator
     *
     * @param ServiceLocatorInterface $serviceLocator
     */
    public function setServiceLocator(ServiceLocatorInterface $serviceLocator)
    {
        $this->serviceLocator = $serviceLocator;
    }

    /**
     * Get service locator
     *
     * @return ServiceLocatorInterface
     */
    public function getServiceLocator()
    {
        return $this->serviceLocator;
    }
}