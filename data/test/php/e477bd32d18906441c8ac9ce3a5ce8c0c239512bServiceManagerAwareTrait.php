<?php
namespace Dibber\Tests\Units\Service\Asset;

require_once(__DIR__ . '/Test.php');
require_once(__DIR__ . '/Asset/ServiceManagerAwareTrait.php');

use Dibber\Service;

class ServiceManagerAwareTrait extends \Dibber\Tests\Units\Service\Test
{
    /** @var Service\ServiceManagerAwareTrait */
    protected $serviceManagerAwareTrait;

    public function beforeTestMethod($method)
    {
        $this->serviceManagerAwareTrait = new \mock\Dibber\Service\Asset\ServiceManagerAwareTrait;
    }

    public function testSetService()
    {
        $this
            ->assert('service is set and retreived')
                ->if($serviceManager = $this->application->getServiceManager())
                ->and($this->serviceManagerAwareTrait->setServiceManager($serviceManager))
                ->then
                    ->object($this->serviceManagerAwareTrait->getServiceManager())
                        ->isIdenticalTo($serviceManager)
        ;
    }
}
