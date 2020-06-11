<?php
namespace samizdam\Geometry\Plane;

use samizdam\Geometry\GeometryUnitTestCase;
use samizdam\Geometry\Plane\Point\Point;

/**
 *
 * @author samizdam
 *        
 */
class PlaneGeometryTest extends GeometryUnitTestCase
{

    public function testCreateLine()
    {
        $facade = new PlaneGeometry();
        $this->assertInstanceOf(Lines\LineInterface::class, $facade->createLine(new Point(0, 0), new Point(1, 1)));
    }

    public function testCreateLineSegment()
    {
        $facade = new PlaneGeometry();
        $this->assertInstanceOf(Lines\LineSegmentInterface::class, $facade->createLineSegment(new Point(0, 0), new Point(1, 1)));
    }

    public function testCreatePolygonByPoints()
    {
        $facade = new PlaneGeometry();
        $this->assertInstanceOf(Polygons\PolygonInterface::class, $facade->createPolygonByPoints([]));
    }

    public function testCreateRay()
    {
        $facade = new PlaneGeometry();
        $this->assertInstanceOf(Lines\RayInterface::class, $facade->createRay(new Point(0, 0), new Point(1, 1)));
    }

    public function testGetCurvesFactory()
    {
        $facade = new PlaneGeometry();
        $this->assertInstanceOf(Curves\CurvesFactoryInterface::class, $facade->getCurvesFactory());
    }

    public function testGetLineFactory()
    {
        $facade = new PlaneGeometry();
        $this->assertInstanceOf(Lines\LineFactory::class, $facade->getLineFactory());
    }

    public function testGetPolygonFactory()
    {
        $facade = new PlaneGeometry();
        $this->assertInstanceOf(Polygons\PolygonFactory::class, $facade->getPolygonFactory());
    }

    public function testSetGetFactory()
    {
        $facade = new PlaneGeometry();
        $facade->setFactory(Curves\CurvesFactoryInterface::class, AnotherCurvesFactoryImpl::class);
        $this->assertInstanceOf(AnotherCurvesFactoryImpl::class, $facade->getFactory(Curves\CurvesFactoryInterface::class));
    }
}

class AnotherCurvesFactoryImpl extends Curves\CurvesFactory
{
}