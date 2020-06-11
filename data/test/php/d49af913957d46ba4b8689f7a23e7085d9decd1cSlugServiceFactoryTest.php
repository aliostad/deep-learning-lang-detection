<?php

namespace Eye4web\Zf2BoardTest\Factory\Service;

use Eye4web\Zf2Board\Factory\Service\SlugServiceFactory;
use Zend\Mvc\Controller\ControllerManager;
use PHPUnit_Framework_TestCase;
use Zend\ServiceManager\ServiceLocatorInterface;

class SlugServiceFactoryTest extends PHPUnit_Framework_TestCase
{
    /** @var SlugServiceFactory */
    protected $factory;

    /** @var ServiceLocatorInterface */
    protected $serviceLocator;

    public function setUp()
    {
        /** @var ServiceLocatorInterface $serviceLocator */
        $serviceLocator = $this->getMock('Zend\ServiceManager\ServiceLocatorInterface');
        $this->serviceLocator = $serviceLocator;

        $factory = new SlugServiceFactory;
        $this->factory = $factory;
    }

    public function testCreateService()
    {
        $result = $this->factory->createService($this->serviceLocator);
        $this->assertInstanceOf('Eye4web\Zf2Board\Service\SlugService', $result);
    }
}
