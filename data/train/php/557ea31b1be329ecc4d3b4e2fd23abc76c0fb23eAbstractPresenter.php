<?php
namespace Xi\Zend\Mvc\Presenter;

use Xi\Zend\Mvc\ActionController,
    Xi\Zend\Mvc\DependencyInjection\PresenterServiceLocator;

abstract class AbstractPresenter implements \Xi\Zend\Mvc\Presenter
{
    /**
     * @var PresenterServiceLocator $serviceLocator 
     */
    private $serviceLocator;
    
    /**
     * @param PresenterLocator $serviceLocator
     */
    public function __construct($serviceLocator)
    {
        $this->serviceLocator = $serviceLocator;
        $this->init();
    }
    
    /**
     * @return PresenterLocator
     */
    public function getServiceLocator()
    {
        return $this->serviceLocator;
    }
    
    /**
     * Template method ran on construction
     * 
     * @return void
     */
    protected function init()
    {}
}