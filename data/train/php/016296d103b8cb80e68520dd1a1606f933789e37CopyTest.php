<?php

/**
 * This file is part of the Axstrad library.
 *
 * (c) Dan Kempster <dev@dankempster.co.uk>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 *
 * @copyright 2014-2015 Dan Kempster <dev@dankempster.co.uk>
 */

namespace Axstrad\Component\Content\Tests\Unit\Traits;

use Axstrad\Component\Content\Exception\InvalidArgumentException;
use Axstrad\Component\Content\Tests\Stubs\Traits\CopyTraitStub;

/**
 * Axstrad\Component\Content\Tests\Unit\Traits\CopyTest
 *
 * @author Dan Kempster <dev@dankempster.co.uk>
 * @license MIT
 * @package Axstrad/Content
 * @subpackage Tests
 * @group unit
 */
class CopyTest extends \PHPUnit_Framework_TestCase
{
    /**
     * @var CopyTraitStub
     */
    protected $fixture;

    public function setUp()
    {
        $this->fixture = new CopyTraitStub;
    }

    /**
     * @covers Axstrad\Component\Content\Traits\Copy::getCopy
     */
    public function testGetCopyMethod1()
    {
        $this->assertNull(
            $this->fixture->getCopy()
        );
    }

    /**
     * @covers Axstrad\Component\Content\Traits\Copy::setCopy
     */
    public function testCanSetCopy()
    {
        $this->fixture->setCopy('Some more copy.');
        $this->assertAttributeEquals(
            'Some more copy.',
            'copy',
            $this->fixture
        );
    }

    /**
     * @covers Axstrad\Component\Content\Traits\Copy::getCopy
     * @depends testCanSetCopy
     * @uses Axstrad\Component\Content\Traits\Copy::setCopy
     */
    public function testGetCopyMethod2()
    {
        $this->fixture->setCopy('My copy');
        $this->assertEquals(
            'My copy',
            $this->fixture->getCopy()
        );
    }

    /**
     * @covers Axstrad\Component\Content\Traits\Copy::setCopy
     */
    public function testSetCopyReturnsSelf()
    {
        $this->assertSame(
            $this->fixture,
            $this->fixture->setCopy('foo')
        );
    }

    /**
     * @covers Axstrad\Component\Content\Traits\Copy::setCopy
     * @depends testCanSetCopy
     */
    public function testCopyIsTypeCastToString()
    {
        $this->fixture->setCopy(1.1);
        $this->assertAttributeEquals(
            '1.1',
            'copy',
            $this->fixture
        );
    }

    /**
     * @covers Axstrad\Component\Content\Traits\Copy::setCopy
     * @depends testCanSetCopy
     */
    public function testCopyCanBeSetToNull()
    {
        $this->fixture->setCopy('My Copy');
        $this->fixture->setCopy(null);
        $this->assertAttributeEquals(
            null,
            'copy',
            $this->fixture
        );
    }

    /**
     * @expectedException InvalidArgumentException
     * @covers Axstrad\Component\Content\Traits\Copy::setCopy
     */
    public function testSetCopyThrowsExceptionIfArgumentIsNotScalar()
    {
        $this->fixture->setCopy($this);
    }
}
