<?php

namespace Labs\Image\Service\Factory;

use Labs\Image\Service\ImageService;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class ImageServiceFactory implements FactoryInterface {

    public function createService(ServiceLocatorInterface $serviceLocator) {
        $imageService = new ImageService();
        $imageService->setPathService($serviceLocator->get('Labs\Image\Service\PathService'));
        $imageService->setConfiguration($serviceLocator->get('Configuration'));
        return $imageService;
    }

}