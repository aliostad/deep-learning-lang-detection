<?php
namespace FileUpload\Service;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

/**
 * Description of FileUploadServiceFactory
 *
 * @author aqnguyen
 */
class FileUploadServiceFactory implements FactoryInterface
{
    /**
     * Create Service Factory
     * 
     * @param ServiceLocatorInterface $serviceLocator
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $db   = $serviceLocator->get('doctrine.entitymanager.orm_default');
        $service = new FileUploadService();
        $service->setDb($db);
        return $service;
    }
}
