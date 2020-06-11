<?php
namespace Api\V1\Rpc\Subscription;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;


class SubscriptionControllerFactory implements FactoryInterface
{

    /**
     * Create service
     *
     * @param \Zend\ServiceManager\ServiceLocatorInterface $controller
     * @return mixed
     */
    public function createService(ServiceLocatorInterface $controller)
    {
        $serviceLocator = $controller->getServiceLocator();

        $logger = $serviceLocator->get('Psr\\Log\\LoggerInterface');

        $authentication = $serviceLocator->get('Api\\V1\\Security\\Authentication\\AuthenticationService');
        $authorization = $serviceLocator->get('Api\\V1\\Security\\Authorization\\AclAuthorization');
        $subscriptionService = $serviceLocator->get('Api\\V1\\Service\\SubscriptionService');
        $userService = $serviceLocator->get('Api\\V1\\Service\\UserService');
        $giftService = $serviceLocator->get('Api\\V1\\Service\\GiftCardService');

        $webConfig = $serviceLocator->get('config')['web'];

        /** @var \Perpii\Message\EmailManager $emailManager */
        $emailManager = $serviceLocator->get('Perpii\\Message\\EmailManager');

        return new SubscriptionController($webConfig, $subscriptionService, $userService, $giftService, $authentication,
            $authorization, $emailManager, $logger);
    }
}
