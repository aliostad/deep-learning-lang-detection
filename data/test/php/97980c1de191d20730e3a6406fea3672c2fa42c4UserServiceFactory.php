<?php
namespace Mostad\User\Factory\Service;

use Mostad\User\Service\UserService;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

/**
 * Class UserServiceFactory
 *
 * @package Mostad\User\Factory\Service
 */
class UserServiceFactory implements FactoryInterface
{
    /**
     * {@inheritdoc}
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        /**
         * @var \Doctrine\Common\Persistence\ObjectManager $objectManager
         * @var \Zend\ServiceManager\ServiceManager        $serviceLocator
         */
        $objectManager = $serviceLocator->get('Mostad\ObjectManager');

        return new UserService($objectManager);
}}
