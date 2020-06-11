<?php
/**
 * Created by PhpStorm.
 * User: guenter
 * Date: 04.04.14
 * Time: 20:40
 */

namespace FSWPresentation\Services;

use FSWPresentation\Services\Facade\PublicationsFacade;
use FSWPresentation\Services\Facade\QArbFacade;
use Zend\ServiceManager\ServiceManager;





class Factory {

    public static function getPublicationsFacade(ServiceManager $sm) {

        $facade = new PublicationsFacade();
        return $facade;

    }


    public static function getQArbFacade(ServiceManager $sm) {

        $facade = new QArbFacade();
        return $facade;

    }



} 