<?php
/**
 * PureMVC PHP Unit Tests
 * @author Omar Gonzalez :: omar@almerblank.com
 * @author Hasan Otuome :: hasan@almerblank.com 
 * 
 * Created on Sep 24, 2008
 * PureMVC - Copyright(c) 2006-2008 Futurescale, Inc., Some rights reserved.
 * Your reuse is governed by the Creative Commons Attribution 3.0 Unported License
 */
require_once 'org/puremvc/php/patterns/facade/Facade.php';
require_once 'org/puremvc/php/patterns/mediator/Mediator.php';
require_once 'org/puremvc/php/patterns/proxy/Proxy.php';

require_once 'PHPUnit/Framework/TestCase.php';

require_once 'FacadeTestCommand.php';
require_once 'FacadeTestVO.php';

/**
 * Facade test case.
 */
class FacadeTest extends PHPUnit_Framework_TestCase
{	
	/**
	 * @var Facade
	 */
	private $Facade;
	
	/**
	 * Prepares the environment before running a test.
	 */
	protected function setUp()
	{
		parent::setUp();
	}
	
	/**
	 * Cleans up the environment after running a test.
	 */
	protected function tearDown()
	{
		parent::tearDown();
	}
	
	/**
	 * Constructs the test case.
	 */
	public function __construct(){}
	
	/**
	 * Tests the Facade Singleton Factory Method.
	 */
	public function testGetInstance()
	{
		// Test Factory Method
   		$facade = Facade::getInstance();
   		
   		// test assertions
   		$this->assertTrue( $facade != null, "Expecting instance not null" );
   		$this->assertTrue( $facade instanceof IFacade, "Expecting instance implements IFacade" );
	}
	/**
	 * Tests Command registration and execution via the Facade.
	 * 
	 * <P>
  	 * This test gets the Singleton Facade instance 
  	 * and registers the FacadeTestCommand class 
  	 * to handle 'FacadeTest' Notifcations.<P>
  	 * 
  	 * <P>
  	 * It then sends a notification using the Facade. 
  	 * Success is determined by evaluating 
  	 * a property on an object placed in the body of
  	 * the Notification, which will be modified by the Command.</P>
	 */
	public function testRegisterCommandAndSendNotification()
	{
		// Create the Facade, register the FacadeTestCommand to 
   		// handle 'FacadeTest' notifications
   		$facade = Facade::getInstance();
   		$facade->registerCommand( 'FacadeTestNote', new FacadeTestCommand() );
   		

		// Send notification. The Command associated with the event
		// (FacadeTestCommand) will be invoked, and will multiply 
		// the vo.input value by 2 and set the result on vo.result
   		$vo = new FacadeTestVO( 32 );
   		$facade->sendNotification( 'FacadeTestNote', $vo );
   		
   		// test assertions 
   		$this->assertTrue( $vo->result == 64, "Expecting vo->result == 64" );
	}
	
	/**
  	 * Tests Command removal via the Facade.
  	 * 
  	 * <P>
  	 * This test gets the Singleton Facade instance 
  	 * and registers the FacadeTestCommand class 
  	 * to handle 'FacadeTest' Notifcations. Then it removes the command.<P>
  	 * 
  	 * <P>
  	 * It then sends a Notification using the Facade. 
  	 * Success is determined by evaluating 
  	 * a property on an object placed in the body of
  	 * the Notification, which will NOT be modified by the Command.</P>
  	 * 
  	 */
  	public function testRegisterAndRemoveCommandAndSendNotification()
  	{	
   		// Create the Facade, register the FacadeTestCommand to 
   		// handle 'FacadeTest' events
   		$facade = Facade::getInstance();
   		$facade->registerCommand( 'FacadeTestNote', new FacadeTestCommand() );
   		$facade->removeCommand( 'FacadeTestNote' );
   		

		// Send notification. The Command associated with the event
		// (FacadeTestCommand) will NOT be invoked, and will NOT multiply 
		// the vo.input value by 2 
   		$vo = new FacadeTestVO( 32 );
   		$facade->sendNotification( 'FacadeTestNote', $vo );
   		
   		// test assertions 
   		$this->assertTrue( $vo->result != 64, "Expecting vo->result != 64" );
   	}
   	
	/**
  	 * Tests the regsitering and retrieving Model proxies via the Facade.
  	 * 
  	 * <P>
  	 * Tests <code>registerProxy</code> and <code>retrieveProxy</code> in the same test.
  	 * These methods cannot currently be tested separately
  	 * in any meaningful way other than to show that the
  	 * methods do not throw exception when called. </P>
  	 */
  	public function testRegisterAndRetrieveProxy()
  	{	
   		// register a proxy and retrieve it.
   		$facade = Facade::getInstance();
		$facade->registerProxy( new Proxy('colors', array('red', 'green', 'blue')) );
		$proxy = $facade->retrieveProxy('colors');
		
		// test assertions
   		$this->assertTrue( $proxy instanceof IProxy, "Expecting proxy is IProxy" );
   		
		// retrieve data from proxy
		$data = $proxy->getData();
		
		// test assertions
   		$this->assertNotNull( $data, "Expecting data not null" );
   		$this->assertTrue( is_array($data), "Expecting data is Array" );
   		$this->assertTrue( sizeof($data) == 3, "Expecting data.length == 3" );
   		$this->assertTrue( $data[0]  == 'red', "Expecting data[0] == 'red'" );
   		$this->assertTrue( $data[1]  == 'green', "Expecting data[1] == 'green'" );
   		$this->assertTrue( $data[2]  == 'blue', "Expecting data[2] == 'blue'" );
   	}
	
	/**
  	 * Tests the removing Proxies via the Facade.
  	 */
  	public function testRegisterAndRemoveProxy()
  	{	
   		// register a proxy, remove it, then try to retrieve it
   		$facade = Facade::getInstance();
   		$proxy = new Proxy( 'sizes', array('7', '13', '21') );
		$facade->registerProxy( $proxy );
		
		// remove the proxy
		$removedProxy = $facade->removeProxy( 'sizes' );

		// assert that we removed the appropriate proxy
   		$this->assertTrue( $removedProxy->getProxyName() == 'sizes', 
   							"Expecting removedProxy.getProxyName() == 'sizes'" );
		
		// make sure we can no longer retrieve the proxy from the model
		$proxy = $facade->retrieveProxy( 'sizes' );
		
		// test assertions
   		$this->assertNull( $proxy, "Expecting proxy is null" );
   	}
   	
	/**
  	 * Tests registering, retrieving and removing Mediators via the Facade.
  	 */
  	public function testRegisterRetrieveAndRemoveMediator()
  	{
  		// register a mediator, remove it, then try to retrieve it
   		$facade = Facade::getInstance();
		$facade->registerMediator( new Mediator(Mediator::NAME, new stdClass()) );
		
		// retrieve the mediator
   		$this->assertNotNull( $facade->retrieveMediator( Mediator::NAME ), 
   								"Expecting mediator is not null" );

		// remove the mediator
		$removedMediator = $facade->removeMediator( Mediator::NAME );

		// assert that we have removed the appropriate mediator
   		$this->assertTrue( $removedMediator->getMediatorName() == Mediator::NAME, 
   							"Expecting removedMediator.getMediatorName() == Mediator.NAME" );
			
		// assert that the mediator is no longer retrievable
   		$this->assertTrue( $facade->retrieveMediator( Mediator::NAME ) == null, 
   							"Expecting facade.retrieveMediator( Mediator.NAME ) == null )" );	  			
   	}
   	
	/**
	 * Tests Facade->hasProxy()
	 */
	public function testHasProxy()
	{
		// register a Proxy
		$facade = Facade::getInstance();
		$facade->registerProxy( new Proxy('hasProxyTest', array(1, 2, 3)) );
		
   		// assert that the model.hasProxy method returns true
   		// for that proxy name
   		$this->assertTrue( $facade->hasProxy('hasProxyTest') == true, 
   							"Expecting facade.hasProxy('hasProxyTest') == true" );
	}
	
	/**
	 * Tests Facade->hasMediator()
	 */
	public function testHasMediator()
	{
		// register a Mediator
		$facade = Facade::getInstance();
		$facade->registerMediator( new Mediator('facadeHasMediatorTest', new stdClass()) );
		
   		// assert that the $facade->hasMediator method returns true
   		// for that mediator name
   		$this->assertTrue( $facade->hasMediator('facadeHasMediatorTest') == true, 
   								"Expecting facade->hasMediator('facadeHasMediatorTest') == true" );
   					
   		$facade->removeMediator( 'facadeHasMediatorTest' );
   		
   		// assert that the $facade->hasMediator method returns false
   		// for that mediator name
   		$this->assertTrue( $facade->hasMediator('facadeHasMediatorTest') == false, 
   								"Expecting facade->hasMediator('facadeHasMediatorTest') == false" );
	}
	
	/**
	 * Test hasCommand method.
	 */
	public function testHasCommand()
	{
		// register the ControllerTestCommand to handle 'hasCommandTest' notes
   		$facade = Facade::getInstance();
   		$facade->registerCommand( 'facadeHasCommandTest', new FacadeTestCommand() );
   		
   		// test that hasCommand returns true for hasCommandTest notifications 
   		$this->assertTrue( $facade->hasCommand('facadeHasCommandTest') == true, 
   								"Expecting facade->hasCommand('facadeHasCommandTest') == true" );
   		
   		// Remove the Command from the Controller
   		$facade->removeCommand( 'facadeHasCommandTest' );
		
   		// test that hasCommand returns false for hasCommandTest notifications 
   		$this->assertTrue( $facade->hasCommand('facadeHasCommandTest') == false, 
   								"Expecting facade->hasCommand('facadeHasCommandTest') == false" );
	}
}

