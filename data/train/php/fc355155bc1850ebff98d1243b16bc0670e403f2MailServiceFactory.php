<?php

namespace EnliteMail\Service;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use Zend\ServiceManager\ServiceManager;
use EnliteMail\Service\MailService;

class MailServiceFactory implements FactoryInterface
{

    /**
     * Create service
     *
     * @param ServiceLocatorInterface|ServiceManager $serviceLocator
     * @return MailService
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $service = new MailService($serviceLocator);

        /** @var MailServiceOptions $options */
        $options = $serviceLocator->get('EnliteMailServiceOptions');
        $service->setRenderer(
            $serviceLocator->get($options->getRenderer())
        );
        $service->setTransport(
            $serviceLocator->get($options->getTransport())
        );

        return $service;
    }


}
