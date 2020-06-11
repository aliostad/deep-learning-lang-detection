<?php

require_once dirname(__FILE__).'/../vendor/autoload.php';

use Commons\Service\AbstractService;
use Commons\Service\ServiceManager;
use Commons\Service\ServiceManagerAwareInterface;

class HelloService extends AbstractService
{
    public function hello()
    {
        return 'Hello '.$this->getServiceManager()->getService('World')->world();
    }
}

class WorldService extends AbstractService
{
    public function world()
    {
        return 'World';
    }
}

$sm = new ServiceManager();
$sm
    ->addFactory('Hello', function(){
        return new HelloService();
    })
    ->addFactory('World', function(){
        return new WorldService();
    });
    
echo $sm->getService('Hello')->hello()."\n";
