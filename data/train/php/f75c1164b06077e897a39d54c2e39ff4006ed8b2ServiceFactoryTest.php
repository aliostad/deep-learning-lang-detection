<?php

namespace UnitTest\App\Infrastructure;

use App\Infrastructure\ServiceFactory;
use App\Service\CustomersService;
use App\Service\Service;

class ServiceFactoryTest extends \PHPUnit_Framework_TestCase
{
    public function testCreateService()
    {
        $factory = 'Hello';

        $serviceFactory = new ServiceFactory([
            Service::FACTORY_DATABASE => $factory
        ]);

        $service = $serviceFactory->createService('Customers');

        $this->assertTrue($service instanceof CustomersService);
        $this->assertSame($factory, $service->getDatabaseQueryFactory());
    }
}
