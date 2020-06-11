<?php

namespace Deploy\Controller;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class ShowDeploymentControllerFactory implements FactoryInterface
{
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $serviceManager = $serviceLocator->getServiceLocator();

        $projectService = $serviceManager->get('\Deploy\Service\ProjectService');
        $deploymentService = $serviceManager->get('\Deploy\Service\DeploymentService');
        $deploymentLogService = $serviceManager->get('\Deploy\Service\DeploymentLogService');
        $gitRepository = $serviceManager->get('\Deploy\Git\GitRepository');
        $userService = $serviceManager->get('\Deploy\Service\UserService');

        return new ShowDeploymentController(
            $projectService,
            $deploymentService,
            $deploymentLogService,
            $gitRepository,
            $userService
        );
    }
}
