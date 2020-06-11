<?php

namespace Application\View\Helper;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class RefreshMessagesFactory implements FactoryInterface
{
    /**
     * @param ServiceLocatorInterface $serviceLocator
     * @return RefreshMessages|mixed
     */
    function createService(ServiceLocatorInterface $serviceLocator){
        $sm = $serviceLocator->getServiceLocator();
        $service = $sm->get('Zend\Db\Adapter\Adapter');
        $helper = new RefreshMessages($service);
        return $helper;
    }
}