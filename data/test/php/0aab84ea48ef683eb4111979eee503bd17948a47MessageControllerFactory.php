<?php

namespace Message\Services;

use Message\Controller\MessageController;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

/**
 * Class MessageControllerFactory
 *
 * @package Message\Services
 */
class MessageControllerFactory implements FactoryInterface
{

    /**
     * @param \Zend\ServiceManager\ServiceLocatorInterface $services
     *
     * @return \Authentication\Controller\AuthController
     */
    public function createService(ServiceLocatorInterface $services)
    {
        /* @var $serviceManager \Zend\ServiceManager\ServiceManager */
        $serviceManager = $services->getServiceLocator();

        /* @var $repository \Message\Services\RepositoryService */
        $repository =  $serviceManager->get('Message\Services\RepositoryService');

        /* @var $mailService \Message\Services\MailService */
        $mailService = $serviceManager->get('Message\Services\MailService');

        /* @var $formService \Message\Services\MessageFormService */
        $formService = $serviceManager->get('Message\Services\MessageFormService');
        $translator = $serviceManager->get('translator');

        $controller = new MessageController();
        $controller->setRepository($repository);
        $controller->setTranslator($translator);
        $controller->setFormFactory($formService);
        $controller->setMailService($mailService);

        return $controller;
    }
}
