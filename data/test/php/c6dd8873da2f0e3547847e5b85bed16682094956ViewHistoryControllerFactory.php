<?php

namespace Deploy\Controller;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class ViewHistoryControllerFactory implements FactoryInterface
{
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $serviceManager = $serviceLocator->getServiceLocator();

        $projectService = $serviceManager->get('\Deploy\Service\ProjectService');
        $deploymentService = $serviceManager->get('\Deploy\Service\DeploymentService');
        $userService = $serviceManager->get('\Deploy\Service\UserService');

        return new ViewHistoryController($projectService, $deploymentService, $userService);
    }
}
