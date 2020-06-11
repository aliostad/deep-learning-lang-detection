<?php

/*
 *
 * This file is part of the Fluent package.
 *
 * (c) Lorenzo Iannone <lorenzo@fluentphp.net>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 *
 */

require_once __DIR__ . "/../Fixtures/DummyService.php";
require_once __DIR__ . "/../Fixtures/DummyConstructArgsService.php";
require_once __DIR__ . "/../Fixtures/DummyInitService.php";


class PlainServiceBuilderTest extends PHPUnit_Framework_TestCase
{

    protected $dummyServiceConfig;

    protected $dummyServiceConstArgConfig;

    protected $dummyInitServiceConfig;

    protected $serviceBuilder;

    public function setUp() {
        $this->dummyServiceConfig = new \Fluent\Component\ServiceContainer\ServiceConfiguration\ServiceConfiguration(
            "DummyService",
            "\\DummyService",
            "dummyscope"
        );

        $this->dummyServiceConstArgConfig = new \Fluent\Component\ServiceContainer\ServiceConfiguration\ServiceConfiguration(
            "DummyServiceTwo",
            "\\DummyConstructArgsService",
            "dummyscope");

        $this->dummyInitServiceConfig = new \Fluent\Component\ServiceContainer\ServiceConfiguration\ServiceConfiguration(
            "DummyServiceThr",
            "\\DummyInitService",
            "dummyscope",
            [],
            'callMe');

        $this->serviceBuilder = new \Fluent\Component\ServiceContainer\ServiceBuilder\PlainServiceBuilder();
    }

    public function testVoidConstructorVoidInitService() {
        $service = $this->serviceBuilder->build($this->dummyServiceConfig, [],[]);
        $this->assertTrue ($service instanceof \DummyService);
    }

    public function testConstructorService() {
        $service = $this->serviceBuilder->build($this->dummyServiceConstArgConfig, [new DummyService()],[]);
        $this->assertTrue ($service instanceof \DummyConstructArgsService);
    }

    public function testInitService() {
        $service = $this->serviceBuilder->build($this->dummyInitServiceConfig, [],[new DummyService()]);
        $this->assertTrue ($service instanceof \DummyInitService);
        $this->assertTrue ($service->called);
    }


}