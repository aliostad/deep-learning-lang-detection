<?php
/**
 * Created by PhpStorm.
 * User: Jfranco
 * Date: 3/22/2015
 * Time: 11:41 AM
 */

namespace User\Factory;

use Mailing\Service;
use User\Listeners\UserServiceSignupEmailListener;
use Zend\ServiceManager\Exception\ServiceNotCreatedException;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

/**
 * Class UserServiceSignupEmailListenerFactory
 * @package User\Factory
 */
class UserServiceSignupEmailListenerFactory implements FactoryInterface
{
    public function createService(ServiceLocatorInterface $service)
    {
        return new UserServiceSignupEmailListener($this->getMailingService($service));
    }

    /**
     * @param ServiceLocatorInterface $service
     * @return Service
     */
    public function getMailingService(ServiceLocatorInterface $service)
    {
        if (!$service->has('Mailing/Service')) {
            throw new ServiceNotCreatedException('Cannot create listener without Mailing\Service');
        }

        $listener = $service->get('Mailing/Service');

        if (!$listener instanceof Service) {
            throw new ServiceNotCreatedException('Cannot create listener with invalid Mailing\Service');
        }

        return $listener;
    }
}