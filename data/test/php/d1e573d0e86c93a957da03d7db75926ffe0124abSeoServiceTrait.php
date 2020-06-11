<?php

namespace EnliteSeo\Service;

use EnliteSeo\Service\SeoService;
use EnliteSeo\Exception\RuntimeException;
use Zend\ServiceManager\ServiceLocatorAwareInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

trait SeoServiceTrait
{

    /**
     * @var SeoService
     */
    protected $seoService = null;

    /**
     * @param SeoService $seoService
     */
    public function setSeoService(SeoService $seoService)
    {
        $this->seoService = $seoService;
    }

    /**
     * @return SeoService
     * @throws RuntimeException
     */
    public function getSeoService()
    {
        if (null === $this->seoService) {
            if ($this instanceof ServiceLocatorAwareInterface || method_exists($this, 'getServiceLocator')) {
                $this->seoService = $this->getServiceLocator()->get('EnliteSeoService');
            } else {
                if (property_exists($this, 'serviceLocator')
                    && $this->serviceLocator instanceof ServiceLocatorInterface
                ) {
                    $this->seoService = $this->serviceLocator->get('EnliteSeoService');
                } else {
                    throw new RuntimeException('Service locator not found');
                }
            }
        }
        return $this->seoService;
    }


}
