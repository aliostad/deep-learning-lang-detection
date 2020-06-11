<?php
namespace Ipmpdf\Service;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class IpmpdfServiceFactory implements FactoryInterface
{
    /**
     * Create Service Factory
     * 
     * @param ServiceLocatorInterface $serviceLocator
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $defaultDb = $serviceLocator->get('doctrine.entitymanager.orm_default');
        $service = new IpmpdfService($defaultDb);
        $domainService = new DomainService();
        $domainService->setSugarDb($defaultDb);
        $service->setDomainService($domainService);
        $service->setViewRenderer($serviceLocator->get('viewrenderer'));
        $service->setDbaDoctrineManager($serviceLocator->get('doctrine.entitymanager.orm_default_dba'));
        return $service;
    }
}
