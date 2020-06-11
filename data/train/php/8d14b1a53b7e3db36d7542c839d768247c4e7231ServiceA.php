<?php

namespace Rouffj\Tests\Symfony\DI\Fixtures;
/**
 * Class A
 *
 * @author Joseph Rouff <rouffj@gmail.com>
 */
class ServiceA
{
    private $options;
    private $serviceB;
    private $serviceC;
    private $serviceD;

    function __construct(ServiceB $serviceB, array $options, ServiceC $serviceC = null)
    {
        $this->options = $options;
        $this->serviceB = $serviceB;
        $this->serviceC = $serviceC;
    }

    public function setServiceD(ServiceD $serviceD)
    {
        $this->serviceD = $serviceD;
    }

    public function getserviceB()
    {
        return $this->serviceB;
    }

    public function getserviceC()
    {
        return $this->serviceC;
    }

    public function getserviceD()
    {
        return $this->serviceD;
    }

    public function getOptions()
    {
        return $this->options;
    }
}
