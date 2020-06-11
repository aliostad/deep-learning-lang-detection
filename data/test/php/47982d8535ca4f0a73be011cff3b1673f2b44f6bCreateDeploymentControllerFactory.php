<?php

namespace Deploy\Controller;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class CreateDeploymentControllerFactory implements FactoryInterface
{
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $serviceManager = $serviceLocator->getServiceLocator();

        $projectService = $serviceManager->get('\Deploy\Service\ProjectService');
        $deploymentService = $serviceManager->get('\Deploy\Service\DeploymentService');
        $gitRepository = $serviceManager->get('\Deploy\Git\GitRepository');

        return new CreateDeploymentController($projectService, $deploymentService, $gitRepository);
    }
}
