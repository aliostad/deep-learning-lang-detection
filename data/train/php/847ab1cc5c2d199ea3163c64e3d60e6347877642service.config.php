<?php

return array(
    'factories' => array(
        'User\Service\AuthenticationService' => 'User\Service\Factory\AuthenticationServiceFactory',
        'User\Service\AclService' => 'User\Service\Factory\AclServiceFactory',
        'User\Service\RbacService' => 'User\Service\Factory\RbacServiceFactory',
        'User\Service\UserService' => 'User\Service\Factory\UserServiceFactory',
    ),
    'aliases' => array(
        'authentication-service' => 'User\Service\AuthenticationService',
        'acl-service' => 'User\Service\AclService',
        'rbac-service' => 'User\Service\RbacService',
        'user-service' => 'User\Service\UserService',
    ),
);
