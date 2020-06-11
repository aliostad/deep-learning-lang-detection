<?php

namespace MJErwin\SonicScrewdriver\ServiceLocator\Traits;

use Zend\Form\FormElementManager;
use Zend\ServiceManager\ServiceLocatorInterface;
use Zend\ServiceManager\ServiceManager;
use Zend\View\HelperPluginManager;

/**
 * @author Matthew Erwin <matthew.j.erwin@me.com>
 * www.matthewerwin.co.uk
 */
trait ServiceLocatorAwareTrait
{
    /**
     * @var ServiceLocatorInterface
     */
    protected $serviceLocator = null;

    protected $rootServiceLocator = null;

    /**
     * Set service locator
     *
     * @param ServiceLocatorInterface $serviceLocator
     *
     * @return mixed
     */
    public function setServiceLocator(ServiceLocatorInterface $serviceLocator)
    {
        if ($serviceLocator instanceof FormElementManager)
        {
            $this->serviceLocator = $serviceLocator->getServiceLocator();
        }

        $this->serviceLocator = $serviceLocator;

        return $this;
    }

    /**
     * Get service locator
     *
     * @return ServiceLocatorInterface
     */
    public function getServiceLocator()
    {
        return $this->serviceLocator;
    }

    /**
     * @param ServiceLocatorInterface $rootServiceLocator
     */
    public function setRootServiceLocator(ServiceLocatorInterface $rootServiceLocator)
    {
        $this->rootServiceLocator = $rootServiceLocator;
    }

    /**
     * @return ServiceManager
     */
    public function getRootServiceLocator()
    {
        if (!$this->rootServiceLocator)
        {
            if ($this->getServiceLocator() instanceof FormElementManager || $this->getServiceLocator() instanceof HelperPluginManager)
            {
                $this->setRootServiceLocator($this->getServiceLocator()->getServiceLocator());
            }
            else
            {
                $this->setRootServiceLocator($this->getServiceLocator());
            }
        }

        return $this->rootServiceLocator;
    }
} 