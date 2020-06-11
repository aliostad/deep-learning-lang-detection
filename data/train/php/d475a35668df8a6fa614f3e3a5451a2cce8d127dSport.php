<?php namespace Matches\Service\Factory;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class Sport implements FactoryInterface
{
    /**
     * @param ServiceLocatorInterface $serviceLocator
     * @return \Matches\Service\Sport
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $entityManager = $serviceLocator
            ->get('doctrine.entitymanager.orm_default');

        $matchesService = new \Matches\Service\Sport(
            $entityManager->getRepository('Matches\Entity\Sport')
        );

        $matchesService->setServiceManager($serviceLocator);
        $matchesService->setEntityManager($entityManager);

        return $matchesService;
    }
}