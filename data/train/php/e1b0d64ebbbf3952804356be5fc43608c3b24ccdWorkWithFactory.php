<?php

namespace Example;

use SlidesWorker\ServiceLocator\ServiceLocator;
use SlidesWorker\ServiceLocator\FactoryInterface;
use SlidesWorker\ServiceLocator\ServiceLocatorInterface;

class FactoryFoo implements FactoryInterface
{
    public function createService(ServiceLocatorInterface $locator, $cName, $rName)
    {
        return new Service();
    }
}

class Service {}

function FactoryFunction (ServiceLocatorInterface $locator, $cName, $rName)
{
    return new Service();
}


// setup ServiceLocator
$serviceLocator = new ServiceLocator();


// factory as closure
$serviceLocator->setFactory('service1', function (ServiceLocatorInterface $locator) {
    return Service();
});

// factory as closure
$serviceLocator->setFactory('service2', 'FactoryFunction');

// factory as class
$serviceLocator->setFactory('service3', '\Example\FactoryFoo');

// factory as instance
$serviceLocator->setFactory('service4', new FactoryFoo());




// get a service
$service1 = $serviceLocator->get('service1');
$service2 = $serviceLocator->get('service2');
$service3 = $serviceLocator->get('service3');
$service4 = $serviceLocator->get('service4');
