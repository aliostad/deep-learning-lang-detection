<?php
namespace PbxAgi\Service\RecordCall;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use PbxAgi\Service\RecordCall\RecordCallService;

class RecordCallServiceFactory implements FactoryInterface
{

    public function createService(ServiceLocatorInterface $serviceLocator)
    {    	
        return new RecordCallService(        		
        		$serviceLocator->get('ClientImpl'), 
        		$serviceLocator->get('AppConfig'), 
        		$serviceLocator->get('RecordCallService'),
        		$serviceLocator->get('PbxAgi\Cdr\Model\CdrTable')
			);
    }
}
