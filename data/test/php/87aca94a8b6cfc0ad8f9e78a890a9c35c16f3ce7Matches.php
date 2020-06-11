<?php namespace Matches\Service\Factory;

use Matches\Service\MatchesService;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class Matches implements FactoryInterface
{
    /**
     * @param ServiceLocatorInterface $serviceLocator
     * @return MatchesService
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $entityManager = $serviceLocator
            ->get('doctrine.entitymanager.orm_default');

        $matchesService = new MatchesService(
            $entityManager->getRepository('Matches\Entity\Match'),
            $serviceLocator->get('MatchValidator')
        );

        $matchesService->setServiceManager($serviceLocator);
        $matchesService->setEntityManager($entityManager);

        return $matchesService;
    }
}