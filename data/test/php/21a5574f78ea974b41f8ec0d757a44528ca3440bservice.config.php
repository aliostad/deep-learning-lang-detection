<?php
/**
 * @category Kevin Kucera
 * @package rentalmgr
 * @copyright Copyright (c) 2013 Kevin Kucera
 * @user: kevin
 * @date: 9/2/13
 */
namespace User;

use Zend\ServiceManager\ServiceManager;

return array(
    'factories' => array(
        'Auth\Service\Authentication' => function(ServiceManager $sm){
            $service = new \Auth\Service\Authentication;
            $service->setServiceLocator($sm);
            return $service;
        },
    ),
    'services' => array(
        'Auth\Service\RedirectCookie' => new \Auth\Service\RedirectCookie,
    )
);