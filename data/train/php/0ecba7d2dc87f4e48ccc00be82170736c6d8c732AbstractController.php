<?php

namespace Foundation;

use Foundation\Traits\TranslatorAwareTrait;
use Zend\Mvc\Controller\AbstractActionController;
use Zend\Mvc\Controller\ControllerManager;
use Zend\ServiceManager\ServiceLocatorInterface;

abstract class AbstractController extends AbstractActionController
{
    use TranslatorAwareTrait;

    public function setServiceLocator(ServiceLocatorInterface $serviceLocator)
    {
        parent::setServiceLocator($serviceLocator);

        if ($serviceLocator instanceof ControllerManager) {
            $serviceLocator = $serviceLocator->getServiceLocator();
        }

        $translator = $serviceLocator->get('translator');
        $this->setTranslator($translator);
    }


}