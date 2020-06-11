<?php

namespace Campustv\Service\Factory;

use Campustv\Service\Service\Kunde as KundeService;
use Campustv\Service\Cache\Kunde   as KundeServiceCache;

class Kunde implements \Zend\ServiceManager\FactoryInterface {

    protected $enableCache = false;

    public function __construct($enableCache = false) {
        $this->enableCache = $enableCache;
    }

    public function createService(\Zend\ServiceManager\ServiceLocatorInterface $sm) {

        $kundeService = new KundeService();
        $kundeService->setTable($sm->get('Campustv\Model\Table\Kunde'));


        $cache = $sm->get('config')['constants']['Campustv\ServiceCaching'];

        if (!$cache) {
            return $kundeService;
        }

        $kundeServiceCache = new KundeServiceCache();
        $kundeServiceCache->setService($kundeService);
        $kundeServiceCache->setCache($sm->get('Zend\Cache\Storage\Filesystem'));

        return $kundeServiceCache;
    }
}

?>
