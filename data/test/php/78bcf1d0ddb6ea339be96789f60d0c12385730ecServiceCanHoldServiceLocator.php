<?php
namespace Example;

use SlidesWorker\ServiceLocator\ServiceLocator;
use SlidesWorker\ServiceLocator\ServiceLocatorInterface;
use SlidesWorker\ServiceLocator\ServiceLocatorAwareInterface;
use SlidesWorker\ServiceLocator\ServiceLocatorAwareTrait;

// only php 5.4 and higher
class ServiceCanHoldServiceLocator1
{
    use ServiceLocatorAwareTrait;
}

// php 5.3
class ServiceCanHoldServiceLocator2 implements ServiceLocatorAwareInterface
{
    protected $serviceLocator;

    public function setServiceLocator(ServiceLocatorInterface $serviceLocator)
    {
        $this->serviceLocator = $serviceLocator;
    }

    public function getServiceLocator()
    {
        return $this->serviceLocator;
    }
}

// php 5.3
class ServiceCanHoldServiceLocator3
{
    protected $serviceLocator;

    public function setServiceLocator(ServiceLocatorInterface $serviceLocator)
    {
        $this->serviceLocator = $serviceLocator;
    }

    public function getServiceLocator()
    {
        return $this->serviceLocator;
    }
}

// setup ServiceLocator
$serviceLocator = new ServiceLocator();

// Hold with trait
$serviceLocator->setFactory('service1', function (ServiceLocatorInterface $locator) {
    return new ServiceCanHoldServiceLocator1();
});

// Hold with interface
$serviceLocator->setFactory('service2', function (ServiceLocatorInterface $locator) {
    return new ServiceCanHoldServiceLocator1();
});

// Hold with custom
$serviceLocator->setFactory('service3', function (ServiceLocatorInterface $locator) {
    $service = new ServiceCanHoldServiceLocator3();
    $service->setServiceLocator($locator);
    return $service;
});

$serviceLocator->get('service1');
$serviceLocator->get('service2');
$serviceLocator->get('service3');
