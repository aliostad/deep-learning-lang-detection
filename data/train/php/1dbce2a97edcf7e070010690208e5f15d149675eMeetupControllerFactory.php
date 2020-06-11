<?php
namespace Application\Factory;

use Application\Controller\MeetupController;
use Application\Service\AService;
use Application\Service\BService;
use Application\Service\MeetupService;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class MeetupControllerFactory implements FactoryInterface
{
    /**
     * Create service
     *
     * @param ServiceLocatorInterface $serviceLocator
     * @return MeetupController
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $parentLocator = $serviceLocator->getServiceLocator();

        $bService      = $parentLocator->get(BService::class);

        return new MeetupController($bService);
    }
}