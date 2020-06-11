<?php

namespace Pacificnm\Media\Controller\Factory;

use Zend\ServiceManager\ServiceLocatorInterface;
use Pacificnm\Media\Controller\UpdateController;

class UpdateControllerFactory
{

    /**
     * @param ServiceLocatorInterface $serviceLocator
     * @return \Pacificnm\Media\Controller\UpdateController
     */
    public function __invoke(ServiceLocatorInterface $serviceLocator)
    {
        $realServiceLocator = $serviceLocator->getServiceLocator();

        $service = $realServiceLocator->get('Pacificnm\Media\Service\ServiceInterface');

        $form = $realServiceLocator->get('Pacificnm\Media\Form\Form');

        return new UpdateController($service, $form);
    }


}

