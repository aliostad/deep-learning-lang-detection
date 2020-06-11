<?php
namespace Troubleshooting\Service;

use Zend\ServiceManager\FactoryInterface,
    Zend\ServiceManager\ServiceLocatorInterface,
    Zend\Log\Logger;
use Troubleshooting\Table\ExceptionTable;
class ErrorHandlingServiceFactory implements FactoryInterface
{
    /**
     * Create service
     *
     * @param ServiceLocatorInterface $serviceLocator
     * @return mixed
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        /** @var Logger $logger */
        $logger = $serviceLocator->get('Troubleshooting\Service\Logger');

        /** @var ExceptionTable $table */
        $table = $serviceLocator->get('Troubleshooting\Table\Exception');

        /** @var ErrorHandlingService $service */
        $service = new ErrorHandlingService();
        $service->setExceptionTable($table);
        $service->setLogger($logger);
        return $service;
    }

} 