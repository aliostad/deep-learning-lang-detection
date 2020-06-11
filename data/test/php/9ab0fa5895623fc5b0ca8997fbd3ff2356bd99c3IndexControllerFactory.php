<?php
/* 可以在module.config.php里用匿名函数代替 */
namespace Helloworld\Controller;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class IndexControllerFactory implements FactoryInterface
{
	public function createService(ServiceLocatorInterface $serviceLocator)
	{
		$ctr = new IndexController();
		$serviceLocator = $serviceLocator->getServiceLocator();
		$greetingSrv = $serviceLocator
						->get('Helloworld\Service\GreetingService');
		$ctr->setGreetingService($greetingSrv);

		return $ctr;
	}
}
