<?php

namespace Zf2ImageMagick\Service\Factory;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

/**
 * Class ImageMagickFactory
 *
 * @package Zf2ImageMagick\Service\Factory
 */
class ImageMagickFactory implements FactoryInterface
{

    /**
     * @param ServiceLocatorInterface $serviceLocator
     * @return Zf2ImageMagick\Service\ImageMagick
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $service = new \Zf2ImageMagick\Service\ImageMagick();
        $service->setServiceManager($serviceLocator);
        return $service;
    }
}
