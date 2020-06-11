<?php
use STS\Core\Api\DefaultLocationFacade;
use STS\Core;

class DefaultLocationFacadeTest extends \PHPUnit_Framework_TestCase
{
    /**
     * @test
     */
    public function validGetAllRegions()
    {
        $facade = $this->loadFacadeInstance();
        $regions = $facade->getAllRegions();
        $this->assertTrue(is_array($regions));
        $this->assertInstanceOf('STS\Core\Location\RegionDto', $regions[0]);
    }
    /**
     * @test
     */
    public function validGetAllAreas()
    {
        $facade = $this->loadFacadeInstance();
        $areas = $facade->getAllAreas();
        $this->assertTrue(is_array($areas));
        $this->assertInstanceOf('STS\Core\Location\AreaDto', $areas[0]);
    }
    private function loadFacadeInstance()
    {
        $core = Core::getDefaultInstance();
        $facade = $core->load('LocationFacade');
        return $facade;
    }
}
