<?php

namespace Detail\Gaufrette\Service;

use Zend\ServiceManager\InitializerInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use Zend\ServiceManager\ServiceLocatorAwareInterface;

class FilesystemServiceInitializer implements InitializerInterface
{
    /**
     * @param $instance
     * @param ServiceLocatorInterface $serviceLocator
     * @return null
     */
    public function initialize($instance, ServiceLocatorInterface $serviceLocator)
    {
        if ($instance instanceof FilesystemServiceAwareInterface) {
            if ($serviceLocator instanceof ServiceLocatorAwareInterface) {
                $serviceLocator = $serviceLocator->getServiceLocator();
            }

            /** @var \Detail\Gaufrette\Service\FilesystemService $filesystemService  */
            $filesystemService = $serviceLocator->get('Detail\Gaufrette\Service\FilesystemService');

            $instance->setFilesystemService($filesystemService);
        }
    }
}
