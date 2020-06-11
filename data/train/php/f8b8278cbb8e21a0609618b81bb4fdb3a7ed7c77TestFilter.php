<?php
namespace ValuTest\InputFilter\TestAsset;

use Zend\ServiceManager\ServiceLocatorInterface;
use Zend\ServiceManager\ServiceLocatorAwareInterface;
use Zend\Filter\AbstractFilter;

class TestFilter extends AbstractFilter implements ServiceLocatorAwareInterface
{
    private $serviceLocator;
    
    public function filter($value)
    {
        return 'filtered';
    }
    
    public function setServiceLocator(ServiceLocatorInterface $serviceLocator)
    {
        $this->serviceLocator = $serviceLocator;
    }
    
    public function getServiceLocator()
    {
        return $this->serviceLocator;
    }
}