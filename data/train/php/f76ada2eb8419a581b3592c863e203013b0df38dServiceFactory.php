<?php
/**
 * ARTEMIS-IA Office copyright message placeholder.
 *
 * @category  General
 *
 * @author    Andre Hebben <andre.hebben@artemis-ia.eu>
 * @copyright Copyright (c) 2008-2016 ARTEMIS-IA Office (https://artemis-ia.eu)
 */

namespace Program\Service\Factory;

use Affiliation\Service\AffiliationService;
use Doctrine\ORM\EntityManager;
use General\Service\GeneralService;
use Program\Service\CallService;
use Program\Service\ProgramService;
use Project\Service\ProjectService;
use Project\Service\VersionService;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use Zend\ServiceManager\ServiceManager;
use Interop\Container\ContainerInterface;
use Program\Service\AbstractService;
use Program\Service\FormService;

/**
 * Class ServiceFactory
 * @package Program\Service\Factory
 */
final class ServiceFactory implements FactoryInterface
{

    /**
     * @param ContainerInterface|ServiceManager    $container
     * @param string                               $requestedName
     * @param array|null                           $options
     *
     * @return AbstractService
     */
    public function __invoke(ServiceManager $container, $requestedName, array $options = null)
    {
        /** @var AbstractService $service */
        $service = new $requestedName();

        /** @var EntityManager $entityManager */
        $entityManager = $container->get(EntityManager::class);
        $service->setEntityManager($entityManager);

        if ($service instanceof FormService) {
            /** @var FormService $service */
            $service->setServiceManager($container);
        } elseif ($service instanceof CallService) {
            /** @var CallService $service */
            $service->setProjectService($container->get(ProjectService::class));
            $service->setVersionService($container->get(VersionService::class));
            $service->setGeneralService($container->get(GeneralService::class));
        } elseif ($service instanceof ProgramService) {
            /** @var ProgramService $service */
            $service->setAffiliationService($container->get(AffiliationService::class));
        }

        return $service;
    }

    /**
     * @param ServiceLocatorInterface $serviceLocator
     * @param string                  $canonicalName
     * @param string                  $requestedName
     *
     * @return AbstractService
     */
    public function createService(ServiceLocatorInterface $serviceLocator, $canonicalName = null, $requestedName = null)
    {
        return $this($serviceLocator, $requestedName);
    }
}
