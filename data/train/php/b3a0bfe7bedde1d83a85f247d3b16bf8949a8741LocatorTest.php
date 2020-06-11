<?php

use Cti\Di\Manager;
use Cti\Di\Locator;

class LocatorTest extends PHPUnit_Framework_TestCase
{
    function testInstantiate()
    {
        $manager = new Manager;
        $this->assertInstanceOf('Cti\\Di\\Locator', $manager->getLocator());
    }

    function testLocatorManagerLink()
    {
        $this->setExpectedException('Exception');

        $l = new Locator;

        $l->init(new Manager);
        $l->init(new Manager);
    }

    function testLocatorManagerWorkflow()
    {
        $locator = new Locator();
        $locator->register('test', $this);
        $locator->getManager()->setServiceLookup(false);
        $this->assertNotSame($this, $locator->getManager()->get('LocatorTest'));

        $locator = new Locator();
        $locator->register('test', $this);
        $locator->getManager()->setServiceLookup(true);
        $this->assertSame($this, $locator->getManager()->get('LocatorTest'));

        $locator = new Locator();
        $locator->register('test', $this);

        // reference service
        $locator->getManager()->getConfiguration()->set('Common\Module', 'reference', '@test');
        $this->assertSame($locator->getManager()->create('Common\Module')->reference, $this);
        
        // escape string with @
        $locator->getManager()->getConfiguration()->set('Common\Module', 'state', '@@test');
        $this->assertSame($locator->getManager()->create('Common\Module')->state, '@test');

    }

    function testClassLookup()
    {
        $locator = new Locator;
        $this->assertSame($locator->findByClass('Cti\Di\Manager'), $locator->getManager());
        $this->assertNull($locator->findByClass(__CLASS__));
    }

    function testLocatorRegistration()
    {
        $locator = new Locator;
        $this->assertSame($locator, $locator->getManager()->get('Cti\Di\Locator'));
    }

    function testManagerRegistration()
    {
        $manager = new Manager;
        $this->assertSame($manager, $manager->get('Cti\Di\Locator')->getManager());
    }

    function testFailRegistration()
    {
        $this->setExpectedException('Exception');
        $locator = new Locator();
        $locator->parse(array(
            'nullable' => null
        ));
    }

    function testFailArrayRegistration()
    {
        $this->setExpectedException('Exception');
        $locator = new Locator();
        $locator->parse(array(
            'nullable' => array()
        ));
    }

    function testFailParsing()
    {
        $this->setExpectedException('Exception');
        $locator = new Locator;
        $locator->load('?');
    }
    
    function testFileLoading()
    {
        $locator = new Locator;
        $locator->load(__DIR__ . '/resources/services.php');
        $this->assertInstanceOf('Common\Module', $locator->get('module'));
    }


    function testFilesystemLoading()
    {
        $locator = new Locator;
        $locator->load(__DIR__ . '/resources/services.php');
        $this->assertInstanceOf('Common\Module', $locator->get('module'));
    }

    function testLocator()
    {
        $services = array(

            'base' => 'Common\Module',

            'base2' => array('Common\Module', array(
                'state' => 'zzzz'
            )),

            'base3' => array(
                'class' => 'Common\Module',
                'config' => array(
                    'state' => 'q',
                ),
            ),

            'base3x' => array(
                'class' => 'Common\Module',
                'configuration' => array(
                    'state' => 'q',
                ),
            ),

            'base4' => function() {
                return new Common\Module;
            },

            'base5' => array(
                'Common\Module',
                'state' => 'hm'
            ),

            'base6' => array(
                'class' => 'Common\Module', 
                'state' => 'wtf'
            ),

            'base7' => array(
                'class' => 'Common\Module',
                'reference' => '@base6'
            )
        );

        $locator = new Locator();
        $locator->load($services);

        $this->assertInstanceOf('Common\Module', $locator->get('base'));
        $this->assertInstanceOf('Common\Module', $locator->get('base2'));
        $this->assertInstanceOf('Common\Module', $locator->get('base3'));
        $this->assertInstanceOf('Common\Module', $locator->get('base4'));

        $this->assertSame($locator->get('base4'), $locator->get('base4'));

        $this->assertSame($locator->get('base2')->state, 'zzzz');
        $this->assertSame($locator->get('base3')->state, 'q');
        $this->assertSame($locator->get('base3x')->state, 'q');
        $this->assertSame($locator->get('base5')->state, 'hm');
        $this->assertSame($locator->get('base6')->state, 'wtf');

        $this->assertSame($locator->get('base6'), $locator->get('base7')->reference);

        $this->assertSame($locator->get('base6'), $locator->getBase6());

        $app = new Common\Application;
        $locator->register('app', $app);
        $this->assertSame($app, $locator->get('app'));

        // manager is service
        $this->assertSame($locator->get('manager'), $locator->getManager());

        // delimiter getter
        $locator->register('application.module', $locator->get('base'));
        $this->assertSame($locator->getApplicationModule(), $locator->get('base'));

        // property access
        $this->assertSame($locator->base, $locator->getBase());

        // property registration
        $locator->base8 = 'Common\Module';
        $this->assertInstanceOf('Common\Module', $locator->base8);

        // check execute
        $this->assertSame($locator->call('base2', 'getState'), 'zzzz');

        $this->setExpectedException('Exception');
        $locator->get('no-base');
    }

    function testGetterFail()
    {
        $locator = new Locator;
        $this->setExpectedException('Exception');
        $locator->getSomething();

    }
}