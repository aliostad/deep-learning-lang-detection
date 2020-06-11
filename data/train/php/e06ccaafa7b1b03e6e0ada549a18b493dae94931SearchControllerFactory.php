<?php


namespace Album\Controller\Factory;


use Album\Controller\SearchController;
use Album\Service\AlbumService;
use Hotdog\SpotifyExampleApi\SpotifyApiInterface;
use Zend\ServiceManager\AbstractPluginManager;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class SearchControllerFactory implements FactoryInterface
{

    /**
     * Create service
     *
     * @param ServiceLocatorInterface $serviceLocator
     * @return mixed
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        if($serviceLocator instanceof AbstractPluginManager)
        {
            $serviceLocator = $serviceLocator->getServiceLocator();
        }

        /** @var AlbumService $albumService */
        $albumService = $serviceLocator->get('AlbumService');
        $controller = new SearchController();
        $controller->setAlbumService($albumService);
        return $controller;
    }
}