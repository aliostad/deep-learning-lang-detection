<?php

namespace Widgets\Controller\Plugin;

use Zend\Mvc\Controller\Plugin\AbstractPlugin,
    Zend\Authentication\AuthenticationService,
    Widgets\Service\Widgets as WidgetsService;

class Widgets extends AbstractPlugin
{
    /**
     * @var Widgets Service
     */
    protected $service;


	/**
     * Get view.
     *
     * @return var
     */
    public function getService()
    {
        return $this->service;
    }
 
    /**
     * Set Service.
     *
     * @param WidgetsService $widgetsService
     */
    public function setService(WidgetsService $service)
    {    	
        $this->service = $service;
        return $this;
    }
}
