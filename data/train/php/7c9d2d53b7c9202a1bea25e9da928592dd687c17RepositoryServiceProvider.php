<?php

namespace Xsanisty\UserManager\Provider;

use Silex\Application;
use Silex\ServiceProviderInterface;
use Xsanisty\UserManager\Model\Permission;
use Xsanisty\UserManager\Repository\UserRepository;
use Xsanisty\UserManager\Repository\GroupRepository;
use Xsanisty\UserManager\Repository\PermissionRepository;

class RepositoryServiceProvider implements ServiceProviderInterface
{
    public function register(Application $app)
    {
        $app['Xsanisty\UserManager\Repository\UserRepository'] = $app->share(
            function (Application $app) {
                return new UserRepository($app['sentry'], $app['sentry.user']);
            }
        );
        $app->bind('Xsanisty\UserManager\Contract\UserRepositoryInterface', 'Xsanisty\UserManager\Repository\UserRepository');

        $app['Xsanisty\UserManager\Repository\GroupRepository'] = $app->share(
            function (Application $app) {
                return new GroupRepository($app['sentry.group']);
            }
        );
        $app->bind('Xsanisty\UserManager\Contract\GroupRepositoryInterface', 'Xsanisty\UserManager\Repository\GroupRepository');

        $app['Xsanisty\UserManager\Repository\PermissionRepository'] = $app->share(
            function (Application $app) {
                return new PermissionRepository(new Permission);
            }
        );
        $app->bind('Xsanisty\UserManager\Contract\PermissionRepositoryInterface', 'Xsanisty\UserManager\Repository\PermissionRepository');
    }

    public function boot(Application $app)
    {

    }
}
