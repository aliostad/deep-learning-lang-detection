<?php
namespace ValuTest\InputFilter\TestAsset;

use Zend\ServiceManager\ServiceLocatorInterface;
use Zend\ServiceManager\ServiceLocatorAwareInterface;
use Zend\Validator\AbstractValidator;

class TestValidator extends AbstractValidator implements ServiceLocatorAwareInterface
{
    private $serviceLocator;
    
    public function isValid($value)
    {
        return true;
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