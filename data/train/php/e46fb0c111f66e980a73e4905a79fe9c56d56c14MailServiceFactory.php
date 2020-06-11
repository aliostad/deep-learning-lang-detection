<?php

namespace PhowerMailModule\Service\Mail;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use PhowerMailModule\Mail\MailService;

class MailServiceFactory implements FactoryInterface
{

    /**
     * Create mail service
     * 
     * @param ServiceLocatorInterface $serviceLocator
     * @return MailService
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $config = $serviceLocator->get('config');
        $mailConfig = isset($config[MailService::CONFIG_KEY]) ? $config[MailService::CONFIG_KEY] : [];
        return new MailService($mailConfig);
    }

}
