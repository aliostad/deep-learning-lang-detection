<?php

namespace KGMBundle\Tests\Unit;

use KGMBundle\DataRepository;
use KGMBundle\DataRepositoryItem;

/**
 * class for testing data repository
 */
class DataRepositoryTest extends \PHPUnit_Framework_TestCase
{
	/**
	 * @var \KGMBundle\DataRepository $repository DataRepository object
	 */
	protected $repository;
	
	/**
	 * set up test environment, create datarepository object
	 */
	public function setUp()
	{
		$this->repository = new DataRepository();
	}
	
	/**
	 * test repository->__toString
	 *
	 * @access public
	 */
	public function testRepositoryToString()
	{
		$repositoryDump = (string)$this->repository;
		$this->assertContains("['PROTECTED']", $repositoryDump);
		$this->assertContains("['repository']", $repositoryDump);
		$this->assertContains("['constants']", $repositoryDump);
	}
	
	/**
	 * test repository->getConstants
	 *
	 * @access public
	 */
	public function testRepositoryGetConstants()
	{
		$this->assertInstanceOf("\KGMBundle\Configuration\GlobalConstant", $this->repository->getConstants());
	}
	
	/**
	 * test repository->hasRepository
	 *
	 * @access public
	 */
	public function testRepositoryHas()
	{
		$this->assertFalse($this->repository->hasRepository("a"));
	}
	
	/**
	 * test repository->addRepository
	 *
	 * @access public
	 */
	public function testRepositoryAdd()
	{
		$this->repository->addRepository("a", new DataRepositoryItem(array(1, 2)));
		$this->assertTrue($this->repository->hasRepository("a"));
	}
	
	/**
	 * test repository->addRepository
	 *
	 * @access public
	 *
	 * @expectedException \KGMBundle\Exception\DataRepository\ExistingKeyException
	 */
	public function testRepositoryAddExistingKey()
	{
		$this->repository->addRepository("a", new DataRepositoryItem(array(1, 2)));
		$this->repository->addRepository("a", new DataRepositoryItem('x'));
	}
	
	/**
	 * test repository->getRepository
	 *
	 * @access public
	 *
	 * @expectedException \KGMBundle\Exception\DataRepository\MissingKeyException
	 */
	public function testRepositoryGetMissingKey()
	{
		$this->repository->getRepository("a");
	}
	
	/**
	 * test repository->getRepository
	 *
	 * @access public
	 */
	public function testRepositoryGet()
	{
		$this->repository->addRepository("a", new DataRepositoryItem(array(1, 2)));
		$this->assertInstanceOf("\KGMBundle\DataRepositoryItem", $this->repository->getRepository("a"));
		$this->assertInternalType("array", $this->repository->getRepository("a")->getData());
		$this->assertContainsOnly("int", $this->repository->getRepository("a")->getData());
	}
	
	/**
	 * test repository->changeRepository
	 *
	 * @access public
	 *
	 * @expectedException \KGMBundle\Exception\DataRepository\MissingKeyException
	 */
	public function testRepositoryChangeMissingKey()
	{
		$this->repository->changeRepository("a", new DataRepositoryItem(array(3, 4)));
	}
	
	/**
	 * test repository->changeRepository
	 *
	 * @access public
	 */
	public function testRepositoryChange()
	{
		$this->repository->addRepository("a", new DataRepositoryItem(array(1, 2)));
		$this->repository->changeRepository("a", new DataRepositoryItem(array("a", "b")));
		$this->assertContainsOnly("string", $this->repository->getRepository("a")->getData());
	}
	
	/**
	 * test repository->deleteRepository
	 *
	 * @access public
	 *
	 * @expectedException \KGMBundle\Exception\DataRepository\MissingKeyException
	 */
	public function testRepositoryDeleteMissingKey()
	{
		$this->repository->deleteRepository("a");
	}
	
	/**
	 * test repository->deleteRepository
	 *
	 * @access public
	 */
	public function testRepositoryDelete()
	{
		$this->repository->addRepository("a", new DataRepositoryItem(array(1, 2)));
		$this->assertTrue($this->repository->hasRepository("a"));
		$this->repository->deleteRepository("a");
		$this->assertFalse($this->repository->hasRepository("a"));
	}
	
	/**
	 * test repository->moveRepository
	 *
	 * @access public
	 *
	 * @expectedException \KGMBundle\Exception\DataRepository\MissingKeyException
	 */
	public function testRepositoryMoveMissingSourceKey()
	{
		$this->repository->moveRepository("a", "b");
	}
	
	/**
	 * test repository->moveRepository
	 *
	 * @access public
	 *
	 * @expectedException \KGMBundle\Exception\DataRepository\ExistingKeyException
	 */
	public function testRepositoryMoveExistingTargetKey()
	{
		$this->repository->addRepository("a", new DataRepositoryItem(array(1, 2)));
		$this->repository->addRepository("b", new DataRepositoryItem(array(1, 2)));
		$this->assertTrue($this->repository->hasRepository("a"));
		$this->assertTrue($this->repository->hasRepository("b"));
		$this->repository->moveRepository("a", "b");
	}
	
	/**
	 * test repository->moveRepository
	 *
	 * @access public
	 */
	public function testRepositoryMove()
	{
		$this->repository->addRepository("a", new DataRepositoryItem(array(1, 2)));
		$this->repository->moveRepository("a", "b");
		$this->assertFalse($this->repository->hasRepository("a"));
		$this->assertTrue($this->repository->hasRepository("b"));
		$this->assertContainsOnly("int", $this->repository->getRepository("b")->getData());
	}
	
	/**
	 * test repository->cloneRepository
	 *
	 * @access public
	 *
	 * @expectedException \KGMBundle\Exception\DataRepository\MissingKeyException
	 */
	public function testRepositoryCloneeMissingSourceKey()
	{
		$this->repository->cloneRepository("a", "b");
	}
	
	/**
	 * test repository->cloneRepository
	 *
	 * @access public
	 *
	 * @expectedException \KGMBundle\Exception\DataRepository\ExistingKeyException
	 */
	public function testRepositoryCloneExistingTargetKey()
	{
		$this->repository->addRepository("a", new DataRepositoryItem(array(1, 2)));
		$this->repository->addRepository("b", new DataRepositoryItem(array(1, 2)));
		$this->assertTrue($this->repository->hasRepository("a"));
		$this->assertTrue($this->repository->hasRepository("b"));
		$this->repository->cloneRepository("a", "b");
	}
	
	/**
	 * test repository->cloneRepository
	 *
	 * @access public
	 */
	public function testRepositoryClone()
	{
		$this->repository->addRepository("a", new DataRepositoryItem(array(1, 2)));
		$this->repository->cloneRepository("a", "b");
		$this->assertTrue($this->repository->hasRepository("a"));
		$this->assertTrue($this->repository->hasRepository("b"));
		$this->assertEquals($this->repository->getRepository("a"), $this->repository->getRepository("b"));
	}
	
	/**
	 * test repository->__construct(array())
	 *
	 * @access public
	 */
	public function testRepositoryInit()
	{
		$this->repository = new DataRepository(
			array(
				'a' => array(1, 2),
				'b' => array("3", "4"),
			)
		);
		$this->assertTrue($this->repository->hasRepository("a"));
		$this->assertTrue($this->repository->hasRepository("b"));
		$this->assertContainsOnly("int", $this->repository->getRepository("a")->getData());
		$this->assertContainsOnly("string", $this->repository->getRepository("b")->getData());
	}
}
