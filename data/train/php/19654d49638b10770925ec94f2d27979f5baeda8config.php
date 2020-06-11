<?php
namespace Base\View\Helper;

use Zend\View\Helper\AbstractHelper;
use Zend\ServiceManager\ServiceLocatorAwareInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class Config extends AbstractHelper implements ServiceLocatorAwareInterface
{

    public function setServiceLocator(ServiceLocatorInterface $serviceLocator)
    {
        $this->serviceLocator = $serviceLocator;
        return $this;
    }
    
    public function getServiceLocator()
    {
        return $this->serviceLocator;
    }
    
    public function __invoke()
    {
        $serviceLocator = $this->getServiceLocator();
        //d($serviceLocator);
       
    }
}
?>
