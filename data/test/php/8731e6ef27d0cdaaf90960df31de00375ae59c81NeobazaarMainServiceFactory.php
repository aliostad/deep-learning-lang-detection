<?php 
namespace Neobazaar\Service;

use Zend\ServiceManager\ServiceLocatorInterface,
	Zend\ServiceManager\FactoryInterface;

use Neobazaar\Options\ModuleOptions;

class NeobazaarMainServiceFactory
	implements FactoryInterface
{
    /**
     *
     * @param \Zend\ServiceManager\ServiceLocatorInterface $serviceLocator
     * @return \Options\ModuleOptions
     */
    public function createService(ServiceLocatorInterface $sl)
    {			
        $service = new MainModuleService;
        $service->setEntityManager($sl->get('neobazaar.doctrine.em'));
        $service->setView($sl->get('Zend\View\Renderer\PhpRenderer'));
        $service->setServiceManager($sl);
			
        return $service;
    }
}