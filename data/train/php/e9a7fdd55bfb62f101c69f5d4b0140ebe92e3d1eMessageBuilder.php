<?php

namespace DmMailer\Factory\Service;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

use DmMailer\Service\FakeUrl as FakeUrlService;
use DmMailer\Service\MessageBuilder as MessageBuilderService;
use DmMailer\Service\TemplateBuilder as TemplateBuilderService;

class MessageBuilder implements FactoryInterface
{
    /**
     * @param ServiceLocatorInterface $serviceLocator
     *
     * @return MessageBuilderService
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        /** @var FakeUrlService $fakeUrl */
        $fakeUrl = $serviceLocator->get('DmMailer\Service\FakeUrl');

        $templateBuilder = new TemplateBuilderService();
        $messageBuilder  = new MessageBuilderService($templateBuilder, $fakeUrl);

        return $messageBuilder;
    }
}
