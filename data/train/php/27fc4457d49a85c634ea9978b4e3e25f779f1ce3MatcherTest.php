<?php

namespace Series\Tests\Matcher;

use Series\Matcher\Matcher;

use Series\Show\Mine\ShowCollection as MineShowCollection;
use Series\Show\Mine\Show as MineShow;
use Series\Show\Upstream\ShowCollection as UpstreamShowCollection;
use Series\Show\Upstream\ShowAbstract as UpstreamShowAbstract;

class MatcherTest extends \PHPUnit_Framework_TestCase
{

    public function testGetMatchedShowCollection()
    {
        $mineShowCollection = new MineShowCollection();
        $mineShowCollection->addShow(new MineShow('foo', '1.0'));
        $mineShowCollection->addShow(new MineShow('bar', '2.0'));
        $mineShowCollection->addShow(new MineShow('baz', '2.0'));

        $upstreamShowCollection = new UpstreamShowCollection();
        $upstreamShowCollection->addShow(new UpstreamShow('foo', '1.0'));
        $upstreamShowCollection->addShow(new UpstreamShow('foo', '1.1'));
        $upstreamShowCollection->addShow(new UpstreamShow('foo', '1.2'));
        $upstreamShowCollection->addShow(new UpstreamShow('bar', '1.0'));
        $upstreamShowCollection->addShow(new UpstreamShow('baz', '1.0'));
        $upstreamShowCollection->addShow(new UpstreamShow('baz 720', '2.0'));
        $upstreamShowCollection->addShow(new UpstreamShow('baz 1024', '2.0'));

        $statusFake = $this->getMock('Series\Show\Status\StatusInterface');
        $statusFake
            ->expects($this->exactly(5))
            ->method('isAlreadyDownloaded')
            ->will($this->returnValue(false))
        ;

        $matcher = new Matcher($mineShowCollection, $upstreamShowCollection, $statusFake);

        $matchedShowCollection = $matcher->getMatchedShowCollection()->getCollection();

        $this->assertCount(4, $matchedShowCollection);

        $this->assertEquals('1.0', $matchedShowCollection['foo---1.0']->getMineShow()->getVersion());
        $this->assertCount(1, $matchedShowCollection['foo---1.0']->getMatched());
        $this->assertEquals('1.1', $matchedShowCollection['foo---1.1']->getMineShow()->getVersion());
        $this->assertCount(1, $matchedShowCollection['foo---1.1']->getMatched());
        $this->assertEquals('1.2', $matchedShowCollection['foo---1.2']->getMineShow()->getVersion());
        $this->assertCount(1, $matchedShowCollection['foo---1.2']->getMatched());
        $this->assertEquals('2.0', $matchedShowCollection['baz---2.0']->getMineShow()->getVersion());
        $this->assertCount(2, $matchedShowCollection['baz---2.0']->getMatched());

    }

    /**
     * @dataProvider getIsDownloadableTests
     */
    public function testIsDownloadable($mineShow, $upstreamShow, $expected)
    {

        $matcher = new Matcher(new MineShowCollection(), new UpstreamShowCollection());
        $this->assertEquals($expected, $matcher->isDownloadable($mineShow, $upstreamShow));
    }

    public function getIsDownloadableTests()
    {
        return array(
            array(new MineShow('foo', '0.0'), new UpstreamShow('bar', '1.0'), false),
            array(new MineShow('bar', '0.0'), new UpstreamShow('foo', '1.0'), false),
            array(new MineShow('foo', '2.0'), new UpstreamShow('foo', '1.0'), false),
            array(new MineShow('foo', '2.0'), new UpstreamShow('foo', '1.99999999'), false),
            array(new MineShow('foo', '1.0'), new UpstreamShow('foo', '1.1'), true),
            array(new MineShow('foo', '1.0'), new UpstreamShow('foo', '1.0'), true),
        );
    }

}

class UpstreamShow extends UpstreamShowAbstract
{
    public function __construct($title = null, $version = null)
    {
        parent::__construct($title, $version, 'FAKE');
    }
}
