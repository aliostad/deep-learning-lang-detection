<?php
return array(
    'service_manager' => array(
        'invokables' => array(
            'AceLibrary\Service\RegistryService' => 'AceLibrary\Service\RegistryService',
            'AceLibrary\Service\CacheService'    => 'AceLibrary\Service\CacheService',
            'AceLibrary\Service\V3Service'       => 'AceLibrary\Service\V3Service',
            'AceLibrary\Service\V3ProviderService'       => 'AceLibrary\Service\V3ProviderService',
            'AceLibrary\Service\RoamfreeService' => 'AceLibrary\Service\RoamfreeService',
            'AceLibrary\Service\ViatorService'   => 'AceLibrary\Service\ViatorService',    
            'AceLibrary\Service\YelpService'     => 'AceLibrary\Service\YelpService',
            'AceLibrary\Service\ExpediaService' => 'AceLibrary\Service\ExpediaService',
        ),
    ),
    'view_helpers'    => array(
        'invokables' => array(
            'ServiceManager' => 'AceLibrary\View\Helper\ServiceManager',
        ),
    ),
);