<?php

namespace Conference\Factory\Controller;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use Conference\Controller\ConferenceController;

class ConferenceControllerFactory implements FactoryInterface
{
    public function createService(ServiceLocatorInterface $serviceLocator) {

        /**
         * @var $serviceLocator \Zend\Mvc\Controller\ControllerManager
         */
        $service = $serviceLocator->getServiceLocator();
        
        $conferenceForm = $service->get('FormElementManager')->get('Conference\Form\ConferenceForm');
        
        $om = $service->get('Doctrine\ORM\EntityManager');
        $conferenceService = new \Conference\Service\ConferenceService($om);
        $lieuService = new \Conference\Service\LieuService($om);
        
        $controller = new ConferenceController($conferenceForm, $conferenceService, $lieuService);
        
        return $controller;
    }
}
