<?php
namespace INNN\Service;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class MessageServiceFactory implements FactoryInterface
{
    /**
     *
     * @param ServiceLocatorInterface $serviceLocator
     * @return MessageService
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $tick = $serviceLocator->get('Core\Service\Tick');

        $tables['message'] = $serviceLocator->get('INNN\Table\MessageTable');
        $tables['message_view'] = $serviceLocator->get('INNN\Table\MessageView');
        $tables['user'] = $serviceLocator->get('User\Table\UserTable');

        return new MessageService($tick, $tables);
    }
}