<?php

namespace Chunky;

class ChunkTest extends Test
{
    public function testGetSetOption()
    {
        $chunk = new Chunk(1000, 10, ['foo' => 'bar']);
        $this->assertEquals('bar', $chunk->getOption('foo'));

        $chunk->setOption('foo', 'baz');
        $this->assertEquals('baz', $chunk->getOption('foo'));
    }

    public function testInitialEstimate()
    {
        $chunk = new Chunk(500, 0.2);
        $this->assertInstanceOf('Chunky\Chunk', $chunk);
        $this->assertEquals(500, $chunk->getEstimatedSize());

        $chunk->interval(0.2);
        $this->assertEquals(500, $chunk->getEstimatedSize());
    }

    public function testTakingLonger()
    {
        // We target 1000 rows, and 10 seconds
        $chunk = new Chunk(1000, 10);

        // But we took 20 seconds instead!
        $chunk->interval(20);

        // So, now we should try to process less rows
        $this->assertLessThan(1000, $chunk->getEstimatedSize());
    }

    public function testPauseAlways()
    {
        $chunk = new Chunk(1000, 10, ['pause_always' => 10]);
        $chunk->interval(20);
        $this->assertTrue($chunk->getPaused());
    }

    public function testTakingShorter()
    {
        // We target 1000 rows, and 10 seconds
        $chunk = new Chunk(1000, 0.2);
        $chunk->setTarget(10);

        // But we took 5 seconds instead!
        $chunk->interval(5);

        // So, now we should try to process more rows
        $this->assertGreaterThan(1000, $chunk->getEstimatedSize());
    }

    public function testMinMax()
    {
        $chunk = new Chunk(1000, 10, [
            'min'       => 100,
            'max'       => 1000,
            'smoothing' => 0.99
        ]);

        $chunk->interval(0.1);
        $chunk->interval(0.1);
        $chunk->interval(0.1);

        $this->assertEquals(1000, $chunk->getEstimatedSize());

        $chunk->interval(1000);
        $chunk->interval(1000);
        $chunk->interval(1000);

        $this->assertEquals(100, $chunk->getEstimatedSize());
    }

    public function testTakingLongerFractional()
    {
        $chunk = new Chunk(500, 0.2);

        $chunk->interval(0.22);
        $chunk->interval(0.22);
        $chunk->interval(0.22);
        $chunk->interval(0.22);

        $this->assertLessThan(500, $chunk->getEstimatedSize());
    }

    public function testUpdateEstimateSpecificCount()
    {
        $chunk = new Chunk(100, 1);
        $chunk->interval(1, 10000);

        $this->assertEquals(300, $chunk->getEstimatedSize());
    }

    public function testNormalContract()
    {
        $chunk = new Chunk(100, 1);
        $chunk->begin();
        $chunk->end(10);

        $this->assertInternalType('int', $chunk->getEstimatedSize());
    }
}
