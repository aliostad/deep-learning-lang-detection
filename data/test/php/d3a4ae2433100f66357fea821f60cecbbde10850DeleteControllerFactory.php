<?php
// Filename: /module/Mspotter/src/Mspotter/Factory/DeleteControllerFactory.php
namespace Mspotter\Factory;

use Mspotter\Controller\DeleteController;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class DeleteControllerFactory implements FactoryInterface
{
    /**
     * Create service
     *
     * @param ServiceLocatorInterface $serviceLocator
     *
     * @return mixed
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $realServiceLocator = $serviceLocator->getServiceLocator();
        $adService        = $realServiceLocator->get('Mspotter\Service\AdServiceInterface');

        return new DeleteController($adService);
    }
}