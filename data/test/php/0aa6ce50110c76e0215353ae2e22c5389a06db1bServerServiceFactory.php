<?php

/*
 * @author         N3X
 * @copyright      Copyright (c) 2015, Ilya Beliaev
 * @since          Version 1.0
 * 
 * $Id$
 * $Date$
 */

namespace Server\Service;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class ServerServiceFactory implements FactoryInterface{
    
    public function createService(ServiceLocatorInterface $serviceLocator) {
        $oTS      = $serviceLocator->get("TSCore\Service\Teamspeak");
        $oMapper  = $serviceLocator->get("Server\Mapper\Server");
        $oService = new ServerService();
        $oService->setTeamspeakService($oTS);
        $oService->setServerMapper($oMapper);
        return $oService;
    }

}
