<?php
namespace Application\Factory\Controller;

use Application\Controller\RenderController;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class RenderFactory implements FactoryInterface
{
    /**
     * Create service
     *
     * @param ServiceLocatorInterface $serviceLocator
     * @return mixed
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $serviceLocator = $serviceLocator->getServiceLocator();
        return new RenderController(
            $serviceLocator->get('CloudConvert\Api'),
            $serviceLocator->get('Lob\Lob'),
            $serviceLocator->get('Application\Service\Orchestrate\StorageService'),
            $serviceLocator->get('Nexmo\Sms')
        );
    }
}