<?php

namespace Deploy\Controller;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class UpdateRepositoriesControllerFactory implements FactoryInterface
{
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $serviceManager = $serviceLocator->getServiceLocator();

        $projectService = $serviceManager->get('\Deploy\Service\ProjectService');
        $gitRepository = $serviceManager->get('\Deploy\Git\GitRepository');

        return new UpdateRepositoriesController($projectService, $gitRepository);
    }
}
