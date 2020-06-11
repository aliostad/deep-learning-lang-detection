<?php

namespace Mailchimp\Service;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

/**
 * Simple authentication provider factory
 *
 * @author Ingo Walz <ingo.walz@googlemail.com>
 */
class SubscriberServiceFactory implements FactoryInterface
{
    /**
     * {@inheritDoc}
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $service = new Subscriber();
        $service->setMapper($serviceLocator->get('MailchimpMapper'));
        $service->setSubscriberEntity($serviceLocator->get('Mailchimp\Entity\Subscriber'));
        $service->setMailingListEntity($serviceLocator->get('Mailchimp\Entity\MailingList'));
        $service->setMapper($serviceLocator->get('MailchimpMapper'));
        $service->setConfig($serviceLocator->get('MailchimpConfig'));

        return $service;
    }

}
