<?php
namespace Dibber\Tests\Units\Service\Asset;

require_once(__DIR__ . '/Test.php');
require_once(__DIR__ . '/Asset/ServiceAwareTrait.php');

use Dibber\Service;

class ServiceAwareTrait extends \Dibber\Tests\Units\Service\Test
{
    /** @var Service\ServiceAwareTrait */
    protected $serviceAwareTrait;

    public function beforeTestMethod($method)
    {
        $this->serviceAwareTrait = new \mock\Dibber\Service\Asset\ServiceAwareTrait;
    }

    public function testSetService()
    {
        $this
            ->assert('service is set and retreived')
                ->if($service = new Service\User)
                ->and($this->serviceAwareTrait->setService($service))
                ->then
                    ->object($this->serviceAwareTrait->getService())
                        ->isIdenticalTo($service)
        ;
    }
}
