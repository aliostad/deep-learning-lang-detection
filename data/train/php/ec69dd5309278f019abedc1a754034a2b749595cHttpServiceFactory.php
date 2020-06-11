<?php
/**
 * Class HttpServiceFactory | HttpServiceFactory.php
 * @package Faulancer\Service\Factory
 * @author  Florian Knapp <office@florianknapp.de>
 */
namespace Faulancer\Service\Factory;

use Faulancer\Service\HttpService;
use Faulancer\ServiceLocator\FactoryInterface;
use Faulancer\ServiceLocator\ServiceLocatorInterface;

/**
 * Class HttpServiceFactory
 */
class HttpServiceFactory implements FactoryInterface
{

    /**
     * @param ServiceLocatorInterface $serviceLocator
     * @return HttpService
     * @codeCoverageIgnore
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        return new HttpService();
    }

}