<?php

namespace Deploy\Deployer;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class DeployerFactory implements FactoryInterface
{
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $sshOptions = $serviceLocator->get('Deploy\Options\SshOptions');
        $deploymentService = $serviceLocator->get('\Deploy\Service\DeploymentService');
        $projectService = $serviceLocator->get('\Deploy\Service\ProjectService');
        $targetService = $serviceLocator->get('\Deploy\Service\TargetService');
        $taskService = $serviceLocator->get('\Deploy\Service\TaskService');
        $userService = $serviceLocator->get('\Deploy\Service\UserService');
        $gitRepository = $serviceLocator->get('\Deploy\Git\GitRepository');
        $additionalFile = $serviceLocator->get('\Deploy\Service\AdditionalFileService');

        return new Deployer(
            $sshOptions,
            $deploymentService,
            $projectService,
            $targetService,
            $taskService,
            $userService,
            $gitRepository,
            $additionalFile
        );
    }
}
