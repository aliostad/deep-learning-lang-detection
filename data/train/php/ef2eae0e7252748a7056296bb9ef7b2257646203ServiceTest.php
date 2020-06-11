<?php
namespace LbarTest\Service;

class ServiceTest extends \PHPUnit_Framework_TestCase
{
	private $obj; 
	
	public function setUp()
	{
		
	}
	
	public function testOk()
	{
		$ServiceAuth = new AuthService();
		$ServiceExecute = new ExecuteService();
		
		$objService = new \Lbar\Service\Service($ServiceAuth, $ServiceExecute);	
		$this->assertInstanceOf('\Lbar\Service\Service', $objService);
		
		$return = $objService->execute();
		$this->assertEquals(true,$return);
	}
	
	public function testFail()
	{
		$ServiceAuth = new AuthService();
		$ServiceExecute = new ExecuteServiceFail();
		
		$objService = new \Lbar\Service\Service($ServiceAuth, $ServiceExecute);	
		$this->assertInstanceOf('\Lbar\Service\Service', $objService);
		
		$return = $objService->execute();
		$this->assertEquals(false,$return);
	}
}

class AuthService
implements \Lbar\Service\ServiceAuthInterface
{
	public function authService()
	{
		
	}
}

class ExecuteService
implements \Lbar\Service\ServiceExecuteInterface
{
	public function executeService()
	{
		return true;
	}
}

class ExecuteServiceFail
implements \Lbar\Service\ServiceExecuteInterface
{
	public function executeService()
	{
		throw new \Lbar\Service\Exception\Exception('fail');
	}
}
?>