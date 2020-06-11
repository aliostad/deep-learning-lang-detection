<?php
namespace Application\Controller;

use Zend\ServiceManager\FactoryInterface,
    Zend\ServiceManager\ServiceLocatorInterface,
    Pubmed\Service\PubmedService;
class IndexControllerServiceFactory implements FactoryInterface
{
    /**
     * Create service
     *
     * @param ServiceLocatorInterface $serviceLocator
     * @return mixed
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $sl = $serviceLocator->getServiceLocator();
        $controller = new IndexController();
        $controller->setPubmedService($sl->get('Pubmed\Service\Pubmed'));
        return $controller;
    }

} 