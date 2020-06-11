<?php

namespace Bankroll\Service;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class BankrollFactory implements FactoryInterface
{
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $entityManager = $serviceLocator->get('doctrine.entitymanager.orm_default');

        $BankrollService = new BankrollService(
            $entityManager->getRepository('Bankroll\Entity\Bankroll')
        );
        $BankrollService->setServiceManager($serviceLocator);
        $BankrollService->setEntityManager($entityManager);

        return $BankrollService;
    }
}