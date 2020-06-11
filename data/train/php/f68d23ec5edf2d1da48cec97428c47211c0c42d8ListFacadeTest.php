<?php
namespace PatternsTests\Structural\Facade\CountyFacade;

use Patterns\Structural\Bridge\ListRenderer\Lists\ListArray;
use Patterns\Structural\Bridge\ListRenderer\Lists\ListString;
use Patterns\Structural\Facade\CountyFacade\Counters\ClosureCounter;
use Patterns\Structural\Facade\CountyFacade\ListFacade;
use PHPUnit_Framework_TestCase;
use ReflectionClass;
use ReflectionMethod;

class ListFacadeTest extends PHPUnit_Framework_TestCase
{
    /** @var  ListFacade */
    private $_listFacade;

    /** @var  ReflectionClass */
    private $_reflectedListFacade;

    /** @var ReflectionMethod */
    private $_reflectedIsConfiguredMethod;

    public function classesProvider()
    {
        $counterClasses = array(
            '\Patterns\Structural\Facade\CountyFacade\Counters\ClosureCounter',
            '\Patterns\Structural\Facade\CountyFacade\Counters\ForCounter',
        );

        $listClasses = array(
            '\Patterns\Structural\Bridge\ListRenderer\Lists\ListString',
            '\Patterns\Structural\Bridge\ListRenderer\Lists\ListArray',
        );

        $result = array();

        foreach ($counterClasses as $counterClass) {
            foreach ($listClasses as $listClass) {
                $result[] = array($listClass, $counterClass);
            }
        }

        return $result;
    }

    public function setUp()
    {
        $this->_listFacade = ListFacade::GetInstance();

        $this->_reflectedListFacade =
            new ReflectionClass('\Patterns\Structural\Facade\CountyFacade\ListFacade');

        $this->_reflectedIsConfiguredMethod =
            $this->_reflectedListFacade->getMethod('_isConfigured');

        $this->_reflectedIsConfiguredMethod->setAccessible(true);
    }

    public function testListFacadeIsSingleton()
    {
        $listFacade1 = ListFacade::GetInstance();
        $listFacade2 = ListFacade::GetInstance();

        $this->assertSame($listFacade1, $listFacade2);
    }

    /**
     * @expectedException \Patterns\Structural\Facade\CountyFacade\LIstFacadeExceptions\FacadeIsNotConfiguredException
     */
    public function testFacadeNotConfiguredExceptionOnGetItems()
    {
        $this->_listFacade->getItems();
    }

    /**
     * @expectedException \Patterns\Structural\Facade\CountyFacade\LIstFacadeExceptions\FacadeIsNotConfiguredException
     */
    public function testFacadeNotConfiguredExceptionOnGetSummaryValue()
    {
        $this->_listFacade->getSummaryValue();
    }

    public function testIsConfigured()
    {
        $this->assertFalse($this->_reflectedIsConfiguredMethod->invoke($this->_listFacade));

        $this->_listFacade->configure(new ListString(array()));

        $this->assertFalse($this->_reflectedIsConfiguredMethod->invoke($this->_listFacade));

        $this->_listFacade->configure(null, new ClosureCounter());

        $this->assertTrue($this->_reflectedIsConfiguredMethod->invoke($this->_listFacade));
    }

    /**
     * @dataProvider classesProvider
     */
    public function testGetItems($listClass, $counterClass)
    {
        $_items = array(0, 1, 2);

        $this->_listFacade->configure(new $listClass($_items), new $counterClass());

        $this->assertEquals($_items, $this->_listFacade->getItems());
    }

    /**
     * @dataProvider classesProvider
     */
    public function testGetSummaryValue($listClass, $counterClass)
    {
        $_items = array(0, 1, 2);

        $this->_listFacade->configure(new $listClass($_items), new $counterClass());

        $this->assertEquals(3, $this->_listFacade->getSummaryValue());
    }
}