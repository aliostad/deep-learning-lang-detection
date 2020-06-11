<?php
namespace ValuMail\Service;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class MailServiceFactory implements FactoryInterface
{
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $config = $serviceLocator->get('Config');
        
        $service = new MailService();
        $service->setOption('default_from', $config['valu_mail']['default_from']);
        $service->setMailTransport($serviceLocator->get('mail.transport'));
        
        if ($serviceLocator->has('translator')) {
            $service->setTranslator(
                $serviceLocator->get('translator'));
        }
        
        return $service;
    }
}