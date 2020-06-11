<?php
return array(
    'view_manager' => array(
        'template_path_stack' => array(
            'currency' => __DIR__ . '/../view',
        )
    ),
    'service_manager' => array(
        'factories' => array(
            // register core components
            'Api\\V1\\Security\\Role\\UserRoleProvider' => 'Api\\V1\\Security\\Role\\UserRoleProviderFactory',
            'Api\\V1\\Security\\Authorization\\AclAuthorization' => 'Api\\V1\\Security\\Authorization\\AclAuthorizationFactory',
            'Api\\V1\\Security\\Authentication\\AuthenticationService' => 'Api\\V1\\Security\\Authentication\\AuthenticationServiceFactory',

            // register services
            'Api\\V1\\Service\\UserService' => 'Api\\V1\\Service\\Factory\\UserServiceFactory',
            'Api\\V1\\Service\\ProspectService' => 'Api\\V1\\Service\\Factory\\ProspectServiceFactory',
            'Api\\V1\\Service\\ContactService' => 'Api\\V1\\Service\\Factory\\ContactServiceFactory',
            'Api\\V1\\Service\\EventService' => 'Api\\V1\\Service\\Factory\\EventServiceFactory',
            'Api\\V1\\Service\\EmergencyService' => 'Api\\V1\\Service\\Factory\\EmergencyServiceFactory',
            'Api\\V1\\Service\\AssetService' => 'Api\\V1\\Service\\Factory\\AssetServiceFactory',
            'Api\\V1\\Service\\SubscriptionService' => 'Api\\V1\\Service\\Factory\\SubscriptionServiceFactory',
            'Api\\V1\\Service\\PhotoService' => 'Api\\V1\\Service\\Factory\\PhotoServiceFactory',
            'Api\\V1\\Service\\DeviceService' => 'Api\\V1\\Service\\Factory\\DeviceServiceFactory',
            'Api\\V1\\Service\\MessageService' => 'Api\\V1\\Service\\Factory\\MessageServiceFactory',
            'Api\\V1\\Service\\CouponService' => 'Api\\V1\\Service\\Factory\\CouponServiceFactory',
            'Api\\V1\\Service\\Payment\\AuthorizeNetService' => 'Api\\V1\\Service\\Payment\\AuthorizeNetServiceFactory',
            'Api\\V1\\Service\\Payment\\PaypalService' => 'Api\\V1\\Service\\Payment\\PaypalServiceFactory',
            'Api\\V1\\Service\\Payment\\GoogleInAppService' => 'Api\\V1\\Service\\Payment\\GoogleInAppServiceFactory',
            'Api\\V1\\Service\\Payment\\AppleInAppService' => 'Api\\V1\\Service\\Payment\\AppleInAppServiceFactory',
            'Api\\V1\\Service\\GiftCardService' => 'Api\\V1\\Service\\Factory\\GiftCardServiceFactory',
            'Api\\V1\\Service\\SenderService' => 'Api\\V1\\Service\\Factory\\SenderServiceFactory',
            'Api\\V1\\Service\\PlanService' => 'Api\\V1\\Service\\Factory\\PlanServiceFactory',
            'Api\\V1\\Service\\SettingService' => 'Api\\V1\\Service\\Factory\\SettingServiceFactory',

            // register commands
            'Api\\V1\\Service\\Command\\AssetCommand' => 'Api\\V1\\Service\\Command\\AssetCommandFactory',
            'Api\\V1\\Service\\Command\\EventCommand' =>  'Api\\V1\\Service\\Command\\EventCommandFactory',

            /**
             * Transport
             */
            'SlmMail\Mail\Transport\SesTransport'          => 'SlmMail\Factory\SesTransportFactory',

            /**
             * Services
             */
            'SlmMail\Service\SesService'          => 'SlmMail\Factory\SesServiceFactory',

            /**
             * HTTP client
             */
            'SlmMail\Http\Client' => 'SlmMail\Factory\HttpClientFactory',
        ),
    ),
    'slm_mail' => array(
        'http_adapter' => 'Zend\Http\Client\Adapter\Socket',
    ),
);
