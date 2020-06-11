<?php



use \PEIP\Service\ServiceContainer as PEIP_Service_Container;

require_once dirname(__FILE__).'/../../misc/bootstrap.php';

PHPUnit_Util_Fileloader::checkAndLoad(dirname(__FILE__).'/../_files/BaseConnetableTest.php');
PHPUnit_Util_Fileloader::checkAndLoad(dirname(__FILE__).'/../_files/HelloService.php');
PHPUnit_Util_Fileloader::checkAndLoad(dirname(__FILE__).'/../_files/HelloServiceHandler.php');
PHPUnit_Util_Fileloader::checkAndLoad(dirname(__FILE__).'/../_files/NoReplyChannel.php');

class ServiceContainerTest extends BaseConnetableTest
{
    public function setup()
    {
        $this->serviceContainer = new PEIP_Service_Container();
    }

    public function testServiceGetterSetter()
    {
        $service = new HelloService();

        $this->serviceContainer->setService('HelloService', $service);

        $this->assertEquals($service, $this->serviceContainer->getService('HelloService'));
    }

    public function testHasService()
    {
        $service = new HelloService();

        $this->serviceContainer->setService('HelloService', $service);

        $this->assertTrue($this->serviceContainer->hasService('HelloService'));
    }

    public function testDeleteService()
    {
        $service = new HelloService();

        $this->serviceContainer->setService('HelloService', $service);

        $this->assertTrue($this->serviceContainer->hasService('HelloService'));

        $this->serviceContainer->deleteService('HelloService');

        $this->assertFalse($this->serviceContainer->hasService('HelloService'));
    }
}
