<?php

namespace Deploy\Controller;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class ProjectSettingsControllerFactory implements FactoryInterface
{
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $serviceManager = $serviceLocator->getServiceLocator();

        $projectService = $serviceManager->get('\Deploy\Service\ProjectService');
        $taskService = $serviceManager->get('\Deploy\Service\TaskService');
        $targetService = $serviceManager->get('\Deploy\Service\TargetService');
        $additionalFileService = $serviceManager->get('\Deploy\Service\AdditionalFileService');

        return new ProjectSettingsController($projectService, $taskService, $targetService, $additionalFileService);
    }
}
