<?php
namespace Quiz\Service;

use Quiz\Service\QuizLog as QuizLogService;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class QuizLogFactory implements FactoryInterface
{
    /**
     * Create service
     *
     * @param ServiceLocatorInterface $serviceLocator
     * @return mixed
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        /** @var \Doctrine\ORM\EntityManager $em */
        $em = $serviceLocator->get('Doctrine\ORM\EntityManager');

        /** @var \Zend\Authentication\AuthenticationService $authenticationService */
        $authenticationService = $serviceLocator->get('zfcuser_auth_service');

        return new QuizLogService(
            $em,
            $authenticationService
        );
    }
}
