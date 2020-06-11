<?php
namespace Album\Form\AlbumForm\Tabs;

use FormBuilder\Element\Tab;
use Zend\ServiceManager\ServiceLocatorAwareInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class RelationsTab extends Tab implements ServiceLocatorAwareInterface
{
    protected $serviceLocator;
    
    public function init() {
        
    }
    
    public function setServiceLocator(ServiceLocatorInterface $serviceLocator) {
        $this->serviceLocator = $serviceLocator->getServiceLocator();
    }

    public function getServiceLocator() {
        return $this->serviceLocator;
    }
}