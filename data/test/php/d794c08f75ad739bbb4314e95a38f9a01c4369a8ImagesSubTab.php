<?php
namespace Album\Form\AlbumForm\Tabs\GeneralDataTab;

use FormBuilder\Element\SubTab;
use Zend\ServiceManager\ServiceLocatorAwareInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class ImagesSubTab extends SubTab implements ServiceLocatorAwareInterface
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