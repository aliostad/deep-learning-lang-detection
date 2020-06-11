<?php

namespace Deploy\Controller;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class RunDeploymentControllerFactory implements FactoryInterface
{
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $serviceManager = $serviceLocator->getServiceLocator();

        $deployer = $serviceManager->get('\Deploy\Deployer\Deployer');
        $deploymentService = $serviceManager->get('\Deploy\Service\DeploymentService');
        $deploymentLogService = $serviceManager->get('\Deploy\Service\DeploymentLogService');

        return new RunDeploymentController($deployer, $deploymentService, $deploymentLogService);
    }
}
