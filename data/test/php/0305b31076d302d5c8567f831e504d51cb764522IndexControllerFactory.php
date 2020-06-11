<?php

namespace Login\Factory;

use Login\Controller\IndexController;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class IndexControllerFactory implements FactoryInterface
{
  /**
   * Create service
   * @param ServiceLocatorInterface $serviceLocator
   */
  public function createService(ServiceLocatorInterface $serviceLocator)
  {
    $realServiceLocator = $serviceLocator->getServiceLocator();
    $indexService = $realServiceLocator->get('Login\Service\IndexServiceInterface');
    return new IndexController($indexService);
  }


}
