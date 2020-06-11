<?php

namespace Hurricane\Controller;

use Hurricane\ServiceLocator\ServiceLocator;

class Controller
{

    /**
     * @var ServiceLocator
     */
    private $serviceLocator = null;

    /**
     * Controller constructor.
     * @param ServiceLocator $serviceLocator
     */
    public function __construct(ServiceLocator $serviceLocator)
    {
        $this->setServiceLocator($serviceLocator);
    }

    /**
     * @return bool
     */
    public function beforeExecuteRoute()
    {
        echo "<pre>";
        print_r('before execute route');
        echo "</pre>";
        return true;
    }

    /**
     * @return bool
     */
    public function afterExecuteRoute()
    {
        echo "<pre>";
        print_r('after execute route');
        echo "</pre>";
        return true;
    }

    /**
     * @return ServiceLocator
     */
    public function getServiceLocator()
    {
        return $this->serviceLocator;
    }

    /**
     * @param ServiceLocator $serviceLocator
     * @return Controller
     */
    private function setServiceLocator(ServiceLocator $serviceLocator)
    {
        $this->serviceLocator = $serviceLocator;
        return $this;
    }

}