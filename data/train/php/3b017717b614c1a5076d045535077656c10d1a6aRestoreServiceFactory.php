<?php

namespace User\Factory;

use User\Entity\User;
use User\Form\RestoreForm;
use User\Service\RestoreService;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

/**
 * Class RestoreServiceFactory
 * @package User\Factory
 */
class RestoreServiceFactory implements FactoryInterface
{

    /**
     * Create service
     * @param ServiceLocatorInterface $serviceLocator
     * @return mixed
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $service = new RestoreService();
        $service->setServiceLocator($serviceLocator);

        $form = new RestoreForm();
        $form->bind(new User());
        $form->setServiceLocator($serviceLocator);
        $service->setForm($form);

        /* Send email after restored a password */
        $service->getEventManager()->attach(
            'restore',
            [$serviceLocator->get('SendEmailEvent'), 'registration']
        );

        return $service;
    }
}
